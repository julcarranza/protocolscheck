#####
#
# $Id: load_configuration.pl,v 1.19 2005-03-26 01:59:20 sudeshna Exp $
#
# COPYRIGHT AND LICENSE
# Copyright (c) 2001-2003, Juniper Networks, Inc.  
# All rights reserved.  
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#       1.      Redistributions of source code must retain the above
# copyright notice, this list of conditions and the following
# disclaimer. 
#       2.      Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution. 
#       3.      The name of the copyright owner may not be used to 
# endorse or promote products derived from this software without specific 
# prior written permission. 
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# Name: protocolscheck.pl
# Author: Julio Carranza
# Date:   May 22, 2012
# Description: 
# Verify verify proper behavior of CFM, Core Links, ISIS, LSPs, LDP, 
# L2 Circuits, CCC interfaces, COS queuing and BGP. 
# Verify LLDP and BGP advertising-routes using NET:SSH2::Channel method.
#
#	-CFM. States of the maintenance associations are retrieved.
#	-AE/LACP. Traffics going through the Core AE bundles and the member 
#    links are shown. Load balance between the member links should be observed.
#	-ISIS Adjacencies.
#	-LSPs. LSPs and, primary and secondary path states are shown.
#	-LDP neighbors.
#	-L2 Circuits. Neighbors, Interfaces, Virtual Circuit and last transition
#    are retrieved.
#	-CCC Interfaces. Traffics going through AE bundles facing the CEs
#    and DC routers are shown. Load balance should be observed for the outgoing 
#    packets. VLAN ranges are displayed too.
#	-Queuing for CCC interfaces. Egress traffic should use best-effort queue. 
#	-BGP Peers. It confirms BGP peers and state for the routers.
#	-BGP routes. Communities, AS-Paths, next-hop and age for the BGP routes.
#	-Advertised routes. 
#	-LLDP neighbors.
#
#    Additional files are required
#   -xsl/cfm_csv.xsl
#   -xsl/ae_csv.xsl
#   -xsl/isis_csv.xsl
#   -xsl/lsp_csv.xsl
#   -xsl/ldp_csv.xsl
#   -xsl/l2c_csv.xsl
#   -xsl/ccc_csv.xsl
#   -xsl/queue_csv.xsl
#   -xsl/bgp-peer.xsl
#   -xsl/bgp-route.xsl
#   
#   
# 
#####


use JUNOS::Device;
use JUNOS::Trace;
use strict;
use Getopt::Std;
use Term::ReadKey;
#use warnings;
use Net::SSH2;
use Data::Dumper;

my $access = "ssh";
my $login = "jcarranza";
my $password = "Jcarranza123";

my %deviceinfo = (
        access => $access,
        login => $login,
        password => $password,
    );


my @listofrouters=("20.233.47.41","20.233.47.44","20.233.47.47","20.233.47.20","20.233.47.21");

print "\n*****CFM VERIFICATION*****";
foreach (@listofrouters){
$deviceinfo{hostname}=$_;
cfm_ma(%deviceinfo);
}

print "\n*****AE/LACP VERIFICATION*****";
foreach (@listofrouters){
$deviceinfo{hostname}=$_;
print "\nCore interfaces for $deviceinfo{hostname}\n";
print "\nName            State   Input/Output \n";
core_links(%deviceinfo);
}

print "\n*****ISIS VERIFICATION*****";
foreach (@listofrouters){
$deviceinfo{hostname}=$_;
isis_adj(%deviceinfo);
}

print "\n*****MPLS VERIFICATION*****";
foreach (@listofrouters){
$deviceinfo{hostname}=$_;
print "\nLSP with Paths information for $deviceinfo{hostname}\n";
lsps(%deviceinfo);
}

print "\n*****LDP VERIFICATION*****";
foreach (@listofrouters){
$deviceinfo{hostname}=$_;
print "\nLDP information for $deviceinfo{hostname}\n";
ldp(%deviceinfo);
}

print "\n*****L2 CIRCUITS VERIFICATION*****";
foreach (@listofrouters){
$deviceinfo{hostname}=$_;
print "\nL2Circuits  information for $deviceinfo{hostname}\n";
l2c(%deviceinfo);
}

print "\n*****CCC TRAFFIC VERIFICATION*****";
foreach (@listofrouters){
$deviceinfo{hostname}=$_;
print "\nCCC interfaces for $deviceinfo{hostname}\n";
print "\nInterface/State           Input/Output \n";
print "---------------------------------------------\n";
ccc(%deviceinfo);
}

print "\n*****CCC QUEUING VERIFICATION*****";
foreach (@listofrouters){
$deviceinfo{hostname}=$_;
print "\nCCC Queue Statistics for $deviceinfo{hostname}\n";
print "\nAE      Queue  pps/bps/T-dropped/R-dropped\n";
queue(%deviceinfo);
} 

print "\n*****INSTALLED BGP PEERS VERIFICATION*****";
foreach (@listofrouters){
$deviceinfo{hostname}=$_;
print "\nBGP Peers for $deviceinfo{hostname}\n";
print "---------------------------------------------\n";
bgppeer(%deviceinfo);
}

print "\n*****INSTALLED BGP ROUTES VERIFICATION*****";
foreach (@listofrouters){
$deviceinfo{hostname}=$_;
print "\nBGP Routes learned by $deviceinfo{hostname}\n";
bgproutes(%deviceinfo);
}

print "\n*****ADVERTISING ROUTES to eBGP PEER VERIFICATION*****";
my $host = "20.233.47.21";
my $ssh2 = Net::SSH2->new();
$ssh2->connect( $host ) or die "Unable to connect Host $host \n";
$ssh2->auth_password('jcarranza','Jcarranza123') or die "Unable to login $host \n";
my $chan = $ssh2->channel();
$chan->blocking(0);
$chan->shell();
print "\nVerification of Advertising Routes to eBGP Peer in $host\n";
print "\n";
print $chan " \n";
print "$_" while <$chan>;
sleep 4;
print $chan "show route advertising-protocol bgp 111.111.111.1 detail\n"; 
print "$_" while <$chan>;
sleep 10;
print "\n";




print "\n*****LLDP VERIFICATION*****";
foreach (@stlabrouters){
my $host = $_;
my $ssh2 = Net::SSH2->new();
$ssh2->connect( $host ) or die "Unable to connect Host $@ \n";
$ssh2->auth_password('jcarranza','Jcarranza123') or die "Unable to login $@ \n";
my $chan = $ssh2->channel();
$chan->blocking(0);
$chan->shell();
print "\nVerification of LLDP neighbors in $host\n";
print "\n";
print $chan " \n";
print "$_" while <$chan>;
sleep 4;
print $chan "show lldp neighbors\n"; 
print "$_" while <$chan>;
sleep 10;
print "\n";
}


sub cfm_ma(%deviceinfo)
{
my $xslfile =  "xsl/cfm_csv.xsl";
my $query = "get_cfm_interfaces_information";
my %queryargs = ( detail => 1 );

# connect TO the JUNOScript server
my $jnx = new JUNOS::Device(%deviceinfo);
unless ( ref $jnx ) {
    die "ERROR: $deviceinfo{hostname}: failed to connect.\n";
}

# send the command and receive a XML::DOM object
my $res = $jnx->$query( %queryargs );
unless ( ref $res ) {
    die "ERROR: $deviceinfo{hostname}: failed to execute command $query.\n";
}

# Check and see if there were any errors in executing the command.
# If all is well, output the response using XSLT.
my $err = $res->getFirstError();
if ($err) {
    print STDERR "ERROR: $deviceinfo{'hostname'} - ", $err->{message}, "\n";
} else {
    #
    # Now do the transformation using XSLT.
    #
    my $xmlfile = "$deviceinfo{hostname}-cfm.xml";
    $res->printToFile($xmlfile);
    my $nm = $res->translateXSLtoRelease('xmlns:lc', $xslfile, "$xslfile.tmp");
    if ($nm) {
                print "\nCFM Maintenance Associations for $deviceinfo{hostname}\n";
        my $command = "xsltproc $nm $deviceinfo{hostname}-cfm.xml";
        system($command);
    } else {
        print STDERR "ERROR: Invalid XSL File $xslfile\n";
    }
}

# always close the connection
$jnx->request_end_session();
$jnx->disconnect();
}

sub core_links(%deviceinfo )
{
my $xslfile =  "xsl/ae_csv.xsl";
my $query = "get_interface_information";
my %queryargs = ( detail => 1 );

# connect TO the JUNOScript server
my $jnx = new JUNOS::Device(%deviceinfo);
unless ( ref $jnx ) {
    die "ERROR: $deviceinfo{hostname}: failed to connect.\n";
}

# send the command and receive a XML::DOM object
my $res = $jnx->$query( %queryargs );
unless ( ref $res ) {
    die "ERROR: $deviceinfo{hostname}: failed to execute command $query.\n";
}

# Check and see if there were any errors in executing the command.
# If all is well, output the response using XSLT.
my $err = $res->getFirstError();
if ($err) {
    print STDERR "ERROR: $deviceinfo{'hostname'} - ", $err->{message}, "\n";
} else {
    #
    # Now do the transformation using XSLT.
    #
    my $xmlfile = "$deviceinfo{hostname}-if.xml";
    $res->printToFile($xmlfile);
    my $nm = $res->translateXSLtoRelease('xmlns:lc', $xslfile, "$xslfile.tmp");
    if ($nm) {
        my $command = "xsltproc $nm $deviceinfo{hostname}-if.xml";
        system($command);
    } else {
        print STDERR "ERROR: Invalid XSL File $xslfile\n";
    }
}

# always close the connection
$jnx->request_end_session();
$jnx->disconnect();
}

sub isis_adj(%deviceinfo)
{
my $xslfile =  "xsl/isis_csv.xsl";
my $query = "get_isis_adjacency_information";
my %queryargs = ( detail => 1 );


# connect TO the JUNOScript server
my $jnx = new JUNOS::Device(%deviceinfo);
unless ( ref $jnx ) {
    die "ERROR: $deviceinfo{hostname}: failed to connect, fix your connectivy and try again the
 script.\n";
}

# send the command and receive a XML::DOM object
my $res = $jnx->$query( %queryargs );
unless ( ref $res ) {
    die "ERROR: $deviceinfo{hostname}: failed to execute command $query.\n";
}

# Check and see if there were any errors in executing the command.
# If all is well, output the response using XSLT.
my $err = $res->getFirstError();
if ($err) {
    print STDERR "ERROR: $deviceinfo{'hostname'} - ", $err->{message}, "\n";
} else {
    #
    # Now do the transformation using XSLT.
    #
    my $xmlfile = "$deviceinfo{hostname}-isis.xml";
    $res->printToFile($xmlfile);
    my $nm = $res->translateXSLtoRelease('xmlns:lc', $xslfile, "$xslfile.tmp");
    if ($nm) {
        print "\nISIS adjacencies for $deviceinfo{hostname}\n";
        my $command = "xsltproc $nm $deviceinfo{hostname}-isis.xml";
        system($command);
    } else {
        print STDERR "ERROR: Invalid XSL File $xslfile\n";
    }
}
# always close the connection
$jnx->request_end_session();
$jnx->disconnect();
}

sub lsps(%deviceinfo )
{
my $xslfile =  "xsl/lsp_csv.xsl";
my $query = "get_mpls_lsp_information";
my %queryargs = ( detail => 1 );

# connect TO the JUNOScript server
my $jnx = new JUNOS::Device(%deviceinfo);
unless ( ref $jnx ) {
    die "ERROR: $deviceinfo{hostname}: failed to connect.\n";
}

# send the command and receive a XML::DOM object
my $res = $jnx->$query( %queryargs );
unless ( ref $res ) {
    die "ERROR: $deviceinfo{hostname}: failed to execute command $query.\n";
}

# Check and see if there were any errors in executing the command.
# If all is well, output the response using XSLT.
my $err = $res->getFirstError();
if ($err) {
    print STDERR "ERROR: $deviceinfo{'hostname'} - ", $err->{message}, "\n";
} else {
    #
    # Now do the transformation using XSLT.
    #
    my $xmlfile = "$deviceinfo{hostname}-lsp.xml";
    $res->printToFile($xmlfile);
    my $nm = $res->translateXSLtoRelease('xmlns:lc', $xslfile, "$xslfile.tmp");
    if ($nm) {
        my $command = "xsltproc $nm $deviceinfo{hostname}-lsp.xml";
        system($command);
    } else {
        print STDERR "ERROR: Invalid XSL File $xslfile\n";
    }
}

# always close the connection
$jnx->request_end_session();
$jnx->disconnect();
}

sub ldp(%deviceinfo )
{
# Check to make sure the XSL exists
my $xslfile =  "xsl/ldp_csv.xsl";
my $query = "get_ldp_neighbor_information";
my %queryargs = ( detail => 1 );

# connect TO the JUNOScript server
my $jnx = new JUNOS::Device(%deviceinfo);
unless ( ref $jnx ) {
    die "ERROR: $deviceinfo{hostname}: failed to connect.\n";
}

# send the command and receive a XML::DOM object
my $res = $jnx->$query( %queryargs );
unless ( ref $res ) {
    die "ERROR: $deviceinfo{hostname}: failed to execute command $query.\n";
}

# Check and see if there were any errors in executing the command.
# If all is well, output the response using XSLT.
my $err = $res->getFirstError();
if ($err) {
    print STDERR "ERROR: $deviceinfo{'hostname'} - ", $err->{message}, "\n";
} else {
    #
    # Now do the transformation using XSLT.
    #
    my $xmlfile = "$deviceinfo{hostname}-ldp.xml";
    $res->printToFile($xmlfile);
    my $nm = $res->translateXSLtoRelease('xmlns:lc', $xslfile, "$xslfile.tmp");
    if ($nm) {
        my $command = "xsltproc $nm $deviceinfo{hostname}-ldp.xml";
        system($command);
    } else {
        print STDERR "ERROR: Invalid XSL File $xslfile\n";
    }
}

# always close the connection
$jnx->request_end_session();
$jnx->disconnect();
}

sub l2c(%deviceinfo )
{
my $xslfile1 =  "xsl/l2c_csv.xsl";
my $query = 'get_l2ckt_connection_information';

# connect TO the JUNOScript server
my $jnx = new JUNOS::Device(%deviceinfo);
unless ( ref $jnx ) {
    die "ERROR: $deviceinfo{hostname}: failed to connect.\n";
}

# send the command and receive a XML::DOM object
my $res = $jnx->$query( );

unless ( ref $res ) {
    die "ERROR: $deviceinfo{hostname}: failed to execute command $query.\n";
}

# Check and see if there were any errors in executing the command.
# If all is well, output the response using XSLT.
my $err = $res->getFirstError();
if ($err) {
    print STDERR "ERROR: $deviceinfo{'hostname'} - ", $err->{message}, "\n";
} else {
    #
    # Now do the transformation using XSLT.
    #
    my $xmlfile = "$deviceinfo{hostname}-l2c.xml";
    $res->printToFile($xmlfile);
    my $nm = $res->translateXSLtoRelease('xmlns:lc', $xslfile1, "$xslfile1.tmp");
    if ($nm) {
        my $command = "xsltproc $nm $deviceinfo{hostname}-l2c.xml";
        system($command);
    } else {
        print STDERR "ERROR: Invalid XSL File $xslfile1\n";
    }
}

# always close the connection
$jnx->request_end_session();
$jnx->disconnect();
}

sub ccc(%deviceinfo )
{
# Check to make sure the XSL exists
my $xslfile =  "xsl/ccc_csv.xsl";
my $query = "get_interface_information";
my %queryargs = ( detail => 1 );

# connect TO the JUNOScript server
my $jnx = new JUNOS::Device(%deviceinfo);
unless ( ref $jnx ) {
    die "ERROR: $deviceinfo{hostname}: failed to connect.\n";
}

# send the command and receive a XML::DOM object
my $res = $jnx->$query( %queryargs );
unless ( ref $res ) {
    die "ERROR: $deviceinfo{hostname}: failed to execute command $query.\n";
}

# Check and see if there were any errors in executing the command.
# If all is well, output the response using XSLT.
my $err = $res->getFirstError();
if ($err) {
    print STDERR "ERROR: $deviceinfo{'hostname'} - ", $err->{message}, "\n";
} else {
    #
    # Now do the transformation using XSLT.
    #
    my $xmlfile = "$deviceinfo{hostname}-ccc.xml";
    $res->printToFile($xmlfile);
    my $nm = $res->translateXSLtoRelease('xmlns:lc', $xslfile, "$xslfile.tmp");
    if ($nm) {
        my $command = "xsltproc $nm $deviceinfo{hostname}-ccc.xml";
        system($command);
    } else {
        print STDERR "ERROR: Invalid XSL File $xslfile\n";
    }
}

# always close the connection
$jnx->request_end_session();
$jnx->disconnect();
}

sub bgppeer(%deviceinfo )
{
my $xslfile =  "xsl/bgp-peer.xsl";

# connect TO the JUNOScript server
my $jnx = new JUNOS::Device(%deviceinfo);
unless ( ref $jnx ) {
    die "ERROR: $deviceinfo{hostname}: failed to connect.\n";
}
my $query = "get_bgp_summary_information";

# send the command and receive a XML::DOM object
my $res = $jnx->$query( );
unless ( ref $res ) {
    die "ERROR: $deviceinfo{hostname}: failed to execute command $query.\n";
}

# Check and see if there were any errors in executing the command.
# If all is well, output the response using XSLT.
my $err = $res->getFirstError();
if ($err) {
    print STDERR "ERROR: $deviceinfo{'hostname'} - ", $err->{message}, "\n";
} else {
    #
    # Now do the transformation using XSLT.
    #
    my $xmlfile = "$deviceinfo{hostname}-bgp-peer.xml";
    $res->printToFile($xmlfile);
    my $nm = $res->translateXSLtoRelease('xmlns:lc', $xslfile, "$xslfile.tmp");
    if ($nm) {
        my $command = "xsltproc $nm $deviceinfo{hostname}-bgp-peer.xml";
        system($command);
    } else {
        print STDERR "ERROR: Invalid XSL File $xslfile\n";
    }
}

# always close the connection
$jnx->request_end_session();
$jnx->disconnect();
}

sub bgproutes(%deviceinfo )
{
# Check to make sure the XSL exists
my $xslfile =  "xsl/bgp-route.xsl";
my $query = "get_route_information";
my %queryargs = ( detail => 1 );

# connect TO the JUNOScript server
my $jnx = new JUNOS::Device(%deviceinfo);
unless ( ref $jnx ) {
    die "ERROR: $deviceinfo{hostname}: failed to connect.\n";
}

# send the command and receive a XML::DOM object
my $res = $jnx->$query( %queryargs );
unless ( ref $res ) {
    die "ERROR: $deviceinfo{hostname}: failed to execute command $query.\n";
}

# Check and see if there were any errors in executing the command.
# If all is well, output the response using XSLT.
my $err = $res->getFirstError();
if ($err) {
    print STDERR "ERROR: $deviceinfo{'hostname'} - ", $err->{message}, "\n";
} else {
    #
    # Now do the transformation using XSLT.
    #
    my $xmlfile = "$deviceinfo{hostname}-route.xml";
    $res->printToFile($xmlfile);
    my $nm = $res->translateXSLtoRelease('xmlns:lc', $xslfile, "$xslfile.tmp");
    if ($nm) {
        my $command = "xsltproc $nm $deviceinfo{hostname}-route.xml";
        system($command);
    } else {
        print STDERR "ERROR: Invalid XSL File $xslfile\n";
    }
}

# always close the connection
$jnx->request_end_session();
$jnx->disconnect();
}

sub queue(%deviceinfo )
{
# Check to make sure the XSL exists
my $xslfile =  "xsl/queue_csv.xsl";


# connect TO the JUNOScript server
my $jnx = new JUNOS::Device(%deviceinfo);
unless ( ref $jnx ) {
    die "ERROR: $deviceinfo{hostname}: failed to connect.\n";
}
my $query = "get_interface_queue_information";

# send the command and receive a XML::DOM object
my $res = $jnx->$query( );
unless ( ref $res ) {
    die "ERROR: $deviceinfo{hostname}: failed to execute command $query.\n";
}

# Check and see if there were any errors in executing the command.
# If all is well, output the response using XSLT.
my $err = $res->getFirstError();
if ($err) {
    print STDERR "ERROR: $deviceinfo{'hostname'} - ", $err->{message}, "\n";
} else {
    #
    # Now do the transformation using XSLT.
    #
    my $xmlfile = "$deviceinfo{hostname}-queue.xml";
    $res->printToFile($xmlfile);
    my $nm = $res->translateXSLtoRelease('xmlns:lc', $xslfile, "$xslfile.tmp");
    if ($nm) {
        my $command = "xsltproc $nm $deviceinfo{hostname}-queue.xml";
        system($command);
    } else {
        print STDERR "ERROR: Invalid XSL File $xslfile\n";
    }
}

# always close the connection
$jnx->request_end_session();
$jnx->disconnect();
}


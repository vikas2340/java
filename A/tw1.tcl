Implement 3 nodes point-to-point n/w with duplex links between them. Set queue size, vary the bandwidth & find the number of packets dropped.

#Create a simulator object
set ns [new Simulator]            	/* Letter S is capital */

#Open the NAM trace file
set nf [open tw1.nam w]	/* open a nam trace file in write mode */
$ns namtrace-all $nf

#Open the trace file
set nd [open tw1.tr w]
$ns trace-all $nd

#Define a 'finish' procedure
proc finish {} {	 /* provide space b/w proc & finish and all are in small case */ 
	global ns nf nd
	$ns flush-trace
	
#Close the NAM trace file
	close $nf
	close $nd
	puts "running nam"

#Execute NAM on the trace file
	exec nam tw1.nam
	exit 0
}
#Create three nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

#Create links between the nodes
$ns duplex-link $n0 $n1 1Mb 10ms DropTail   /*Letter M is capital Mb*/
$ns duplex-link $n1 $n2 0.5Mb 10ms DropTail /*Letter D & T are capital */

#Set Queue Size of link (n1-n2) to 5
$ns queue-limit $n1 $n2 5

#Setup a UDP connection
set udp0 [new Agent/UDP]		/* Letters A,U,D and P are capital */
$ns attach-agent $n0 $udp0
set sink [new Agent/Null]			/* Letters A and N are capital */
$ns attach-agent $n2 $sink
$ns connect $udp0 $sink

#Setup a CBR over UDP connection (500 bytes every 5ms)
set cbr0 [new Application/Traffic/CBR]	/* Letters A,T,CBR are capital */
$cbr0 set packetSize_ 500	/*S is capital, space after underscore*/
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

#Schedule events for the CBR  agents
$ns at 0.2 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"

#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"

#Run the simulation
$ns run

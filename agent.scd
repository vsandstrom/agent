(
var swarm = 50;					// Amount of agents created
var num = 2;					// Amount of output channels 
var epoch = 1;					// Number of iteration over all agents
var time = 0.2;					// Epoch time
var doneOnce = false;			// variable to make sure we dont create new arrays for each iteration in Routine. 
var arr = List.new;				// List for containing instances of Agent

~action = Routine.new({
	inf.do({					// Continue until Routine is stopped.

		if ( doneOnce == false, {
			arr = swarm.collect{	// Create 10 instances of Agent with randomized parameters in each.
				Agent.new(exprand(100.0, 500.0), rrand(0, 0.5), rrand(-1.0,1.0), num, rrand(0.01, 0.1), rrand(0.5, 0.8));
			};
			doneOnce = true;				// Sets variable i to 1.
			wait(2);
		});

		arr.do{ | agent, n |
			var freq, pos, fb, vol;


			/*------- DO FUNNY STUFF WITH PARAMETERS -------*/

			
				// do stuff to frequency
			if (arr.wrapAt( n - 1 ).freq + arr.wrapAt( n + 1 ).freq > 2000 || agent.freq == 0, {
					
					freq = 
					rrand( 200.0, 500.0 ).round(
						agent.freq + rrand(-5.0, 5.0))
				}, { 
					freq = ( 
						arr.wrapAt( n-1 ).freq + arr.wrapAt( n+1 ).freq).round(
							arr.wrapAt(n-1).freq + rrand(-3.0, 3.0)) % 1500; 	
				}
			);

				// do stuff to panning position
			if ( arr.wrapAt(n + 1).pos > agent.pos, {
					pos = arr.wrapAt(n-1).pos
				}, {
					pos = agent.pos;
				});

				// do stuff to feedback and volume parameters
			fb = 100 / arr.wrapAt(n - arr.size / 2).freq;
			vol = 1000 / agent.freq % 0.5;
			

			/*---------------- END OF FUNNY ----------------*/


				// Updates values to synth
			agent.setInstance(freq: freq, pos: pos, fb: fb, vol: vol);
				
				// Adds some separation to each synth
			rrand(time / 10, time - 0.001).wait;			

				// sets t_trig of synth to 1
			agent.play;
			
				// beautiful .postln message
			format(
				"Agent 00% |-------------\n|---| freq:     %\n|---| feedback: %\n|---| pos:      %\n|---| vol:      %\n|------------| Agent 00%\nEPOCH: %\n \n", 
				n, freq.round(0.001), fb.round(0.001), pos.round(0.001), vol.round(0.001), n, epoch).postln;
		};
		time.wait;
		epoch = epoch+1;

	});
}).play
);

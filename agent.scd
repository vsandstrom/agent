s.boot;
// TODO: When Routine is run, an Error is thrown: SynthDef agent not found. Don't know why...
// TODO: Got Error: Primitive 'BasicNew' failed. --- I think I solved it by assigning synth in Agent to 'this.synth'
//		 variable.

(
var swarm = 50;
var num = 2;
var time = 0.2;
var i = 0;						// variable to make sure we dont create new arrays for each iteration in Routine. 
var arr = List.new;				// List for containing instances of Agent
~action = Routine.new({
	inf.do({					// Continue until Routine is stopped.

		if ( i == 0, {
			arr = swarm.collect{	// Create 10 instances of Agent with randomized parameters in each.
				Agent.new(exprand(100.0, 500.0), rrand(0, 0.5), rrand(-1.0,1.0), num, rrand(0.01, 0.1), rrand(0.5, 0.8));
			};
			i = 1;				// Sets variable i to 1.
			wait(2);
		});

		arr.do{ | agent, n |
			var freq, pos, fb, vol;
				// Handles edgecases by wrapping around List index if out of bounds

				// do stuff to frequency
			if (arr.wrapAt( n - 1 ).freq + arr.wrapAt( n + 1 ).freq > 2000 || agent.freq == 0, {
					
					freq = rrand( 200.0, 500.0 ).round(agent.freq + rrand(-5.0, 5.0))
				}, { 
					freq = ( arr.wrapAt( n-1 ).freq + arr.wrapAt( n+1 ).freq ).round(arr.wrapAt(n-1).freq + rrand(-3.0, 3.0)) % 1500; 
				});

				// do stuff to panning position
			if ( arr.wrapAt(n + 1).pos > agent.pos, {
					pos = arr.wrapAt(n-1).pos
				}, {
					pos = agent.pos;
				});

				// do stuff to feedback and volume parameters
			fb = 100 / arr.wrapAt(n - arr.size / 2).freq;
			vol = 1000 / agent.freq % 0.5;

				// Updates values to synth
			agent.setInstance(freq: freq, pos: pos, fb: fb, vol: vol);

			rrand(time / 10, time - 0.001).wait;			// Adds some separation to each synth
			agent.play;
			
				// beautiful .postln message
			format(
				"Agent 00" ++ n ++ " |-------------\n|---| freq:     " ++ freq.round(0.001) ++ 
				"\n|---| feedback: "++ fb.round(0.001) ++ 
				"\n|---| pos:      " ++ pos.round(0.001) ++ 
				"\n|---| vol:      " ++ vol.round(0.001) ++ 
				"\n|------------| Agent 00" ++ n ++ "\n \n").postln;
		};
		time.wait;								// Wait before running Routine again. 

	});
}).play
);

~action.play;

~gog = Agent.new(400, 0.2, 0.2);


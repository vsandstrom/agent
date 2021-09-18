s.boot;
// TODO: When Routine is run, an Error is thrown: SynthDef agent not found. Don't know why...
// TODO: Got Error: Primitive 'BasicNew' failed. --- I think I solved it by assigning synth in Agent to 'this.synth'
//		 variable.

(
var num = 2;
var i = 0;						// variable to make sure we dont create new arrays for each iteration in Routine. 
var arr = List.new;				// List for containing instances of Agent
~action = Routine.new({
	inf.do({					// Continue until Routine is stopped.

		if ( i == 0, {
			arr = 10.collect{	// Create 10 instances of Agent with randomized parameters in each.
				Agent.new(exprand(100.0, 500.0), rrand(0, 0.5), rrand(-1.0,1.0), num, rrand(0.01, 1), rrand(0.5, 2.4));
			};
			i = 1;				// Sets variable i to 1.
			wait(2);
		});

		arr.do{ | agent, n |
			var freq, pos, fb;
				// Handles edgecases by wrapping around List index if out of bounds

			if (arr.wrapAt( n - 1 ).freq + arr.wrapAt( n + 1 ).freq > 2000, {
					freq = rrand( 200.0, 500.0 ).round(agent.freq)
				}, {
					freq = ( arr.wrapAt( n-1 ).freq + arr.wrapAt( n+1 ).freq ).round(arr.wrapAt( n+1 ).freq);
				});
			if ( arr.wrapAt(n + 1).pos > agent.pos, {
					pos = arr.wrapAt(n-1).pos
				}, {
					pos = agent.pos;
				});
			fb = arr.wrapAt( n - 1 ).fb;
				// Updates values to synth
			agent.setInstance(freq: freq, pos: pos, fb: fb);

			rrand(0.1, 0.8).wait;			// Adds some separation to each synth
			agent.play;

			format("Agent " ++ n ++ "--- freq: " ++ freq ++ ", feedback: " ++ fb ++ ", pos: " ++ pos ++ " <----").postln;
		};
		1.wait;								// Wait befor running Routine again. 

		// arr.do{ |n|
		// 	arr[n].reset;
		// }

	});
}).play
);

~action.play;

~gog = Agent.new(400, 0.2, 0.2);


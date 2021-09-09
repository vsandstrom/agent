s.boot;
Server.killAll;

// TODO: When Routine is run, an Error is thrown: SynthDef agent not found. Don't know why...
// TODO: Got Error: Primitive 'BasicNew' failed. --- I think I solved it by assigning synth in Agent to 'this.synth'
//		 variable.



SynthDef(\agent, { // SynthDef called in Agent
	var sig, pan, env;

	env = EnvGen.kr(Env.perc(), gate: \t_trig.kr(0));

	sig = SinOscFB.ar(
		freq: \freq.kr(300),
		feedback: \fb.kr(0.5));

	pan = Pan2.ar(sig, \pos.kr(0.5), env);

	Out.ar(0, pan);
}).add;


(
var i = 0;						// variable to make sure we dont create new arrays for each iteration in Routine. 


var arr = List.new;				// List for containing instances of Agent


~action = Routine.new({
	inf.do({					// Continue until Routine is stopped.


		if ( i == 0, {
			arr = 10.collect(	// Create 10 instances of Agent with randomized parameters in each.
				Agent.new( rrand(100, 3000).round(50), rrand(0, 0.5), rrand(-1.0,1.0));
			);
			i = 1;				// Sets variable i to 1.
		});


		arr.size.do{ |n|		// For all instances in arr list, run method ".play", which creates a Synth.new with 
			arr[n].play;		// the parameter values set in step above.
		};


		for ( 0, arr.size - 1, { | j |		// Iterate over entire list and use indexing to check neighbor Agents at 
											// [ j - 1 ] and [ j + 1 ], doing some arbitrary math to update value at index [ j ].

	 		if (j == 0, {					// Handle edge case if there is no Neighbor-Agent "left" of Agent.
				arr[ j ].setInstance(		// Use class method "setInstance" to update variables inside Agent instances.
					( freq: arr[arr.size-1].freq + arr[j+1].freq ) % arr[j].freq,

					pos: if ( arr[j+1].pos > arr[j].pos, {
						arr[j+1].pos
						}, {
						arr[arr.size-1].pos
						} 
					),

					fb: arr[arr.size-1].fb 
					);

			}, { if ( j == arr.size-1, {	// Handle edge case if there is no Neighbor-Agent "right" of Agent.
					arr[ j ].setInstance( 
						( freq: arr[arr.size-2].freq + arr[0].freq ) % arr[j].freq,

						pos: if ( arr[0].pos > arr[j].pos, {
							arr[0].pos
							}, {
							arr[j-1].pos
							} 
						),
						
						fb: arr[arr.size-2].fb 
					);

				}, {						// Else, just check  Neighbor-Agents left and right.
					arr[ j ].setInstance( 
						( freq: arr[j-1].freq + arr[j+1].freq ) % arr[j].freq,
						
						pos: if ( arr[j+1].pos > arr[j].pos, {
							arr[j+1].pos
							}, {
							arr[j-1].pos
							} 
						),

						fb: arr[j+1].fb 
					);

				})
			});
		});
		1.wait;								// Wait befor running Routine again. 
		// arr.size.do{ |n|
		// 	arr[n].reset;
		// }
	});
})
);

~action.play;


~gog = Agent.new(400, 0.2, 0.2);

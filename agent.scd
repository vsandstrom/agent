s.boot;
s.nodeTree;
(
var i = 0;
var arr = List.new;
~action = Routine.new({
	inf.do({
		if ( i == 0, {
			arr = 10.collect(
				Agent.new( rrand(100, 3000).round(50), rrand(0, 0.5), rrand(-1,1), 2 );
			);
			i = 1;
		});
		arr.size.do{ |n|
			arr[n].play;
		};
		for ( 0, arr.size - 1, { | j |
			arr[arr.size].postln;
			if (j == 0, {
				arr[ j ].setInstance( 
					( freq: arr[arr.size-1].freq + arr[j+1].freq ) % arr[j].freq,

					pos: if ( arr[j+1].pos > arr[j].pos, {
						arr[j+1].pos
						}, {
						arr[arr.size-1].pos
						} 
					),

					fb: arr[arr.size-1].fb 
					);

			}, { if ( j == arr.size-1, {
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

				}, {
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
		1.wait;
		// arr.size.do{ |n|
		// 	arr[n].reset;
		// }
	});
})
).play


~gog = Agent.new(400, 0.2, 0.2,2);

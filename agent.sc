Agent { 

	var <>freq = 300, <>fb = 0.4, <>pos = 0.5, <>num = 2, <>atk = 0.01, <>rel = 1, vol = 0.5, <>trig = 0;
	var server;
	var synth;
	var synthName;


	*new{ | freq = 300, fb = 0.4, pos = 0.5, num = 2, atk = 0.01, rel = 1 | // gets arguments on creation of instance.
		^super.newCopyArgs(freq, fb, pos, num, atk, rel).init;


	}

	init { 

		server = Server.local;
		synthName = ("agent_" ++ num.asString ++ "ch").asSymbol;

		server.waitForBoot{

			SynthDef(synthName, { // SynthDef called in Agent
				arg freq = 300, fb = 0.5, pos = 0.5, num = 2, atk = 0.01, rel = 1, t_trig = 0;
				var sig, pan, env;

				env = EnvGen.kr(Env.perc( atk, rel ), t_trig);

				sig = SinOscFB.ar(
					freq: freq, 
					feedback: fb
				);
				
				pan = Pan2.ar(sig, pos, env);

				// I cannot figure out why the PanAz is not working.
				// pan = PanAz.ar( num, sig, pos );

				Out.ar(0, pan * 0.2);
			}).add;

			server.sync;

			synth = Synth(synthName, [
				\freq, this.freq,
				\fb, this.fb,
				\pos, this.pos,
				\num, this.num,
				\atk, this.atk,
				\rel, this.rel,
				\vol, this.vol
			]);

		};

	}

	setInstance { | freq, pos, fb, atk, rel, vol | // Sets new values to class variables.
		if(freq.notNil, {this.freq_( freq )});
		if(pos.notNil, {this.pos_( pos )});
		if(fb.notNil, {this.fb_( fb )});
		if(atk.notNil, {this.atk_( atk )});
		if(rel.notNil, {this.rel_( rel )});
		if(vol.notNil, {this.vol_( vol )});
		
		synth.set(\freq, freq, \fb, fb, \pos, pos, \atk, this.atk, \rel, this.rel, \t_trig, 1, \vol = vol);

	}

	play {  
		this.trig_(1);
		synth.set(\t_trig, this.trig);
	}

	reset { // Unnecessary.
		this.trig_(0);
		synth.set(\t_trig, this.trig);
	}
	
}

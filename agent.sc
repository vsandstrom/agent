Agent { 
	var <>freq, <>fb, <>pos, <>num = 2, <>trig = 0;
	var >synth;


	*new{ | freq, fb, pos, num | // set base arguments on creation of Object.
		SynthDef(\agent, {
			var sig, pan, env;

			env = EnvGen.kr(Env.perc(), gate: this.trig);

			sig = SinOscFB.ar(
				freq: this.freq,
				feedback: this.fb);

			pan = PanAz.ar(this.num, sig, this.pos);

			Out.ar(0, pan*env);
		}).add;
		^super.new.init(freq, fb, pos, num);

	}

	init { | freq, fb, pos, num | // Create the Synth. Setable parameters are frequency, feedback and panning.
		this.freq = freq;
		this.fb = fb;
		this.pos = pos;
		this.num = num;



		^synth = Synth(\agent, [\freq, this.freq, \fb, this.fb, \pos, this.pos, \t_trig, 1]);

	}

	setInstance { | freq, pos, fb | // Sets new values to synth arguments
		this.freq_(freq);
		this.pos_(pos);
		this.fb_(fb);
		synth = Synth(\agent, [\freq, freq, \fb, fb, \pos, pos, \t_trig, 1]);

	}

	play { 
		this.trig_(1);
		synth.set(\t_trig, this.trig);
	}

	reset {
		this.trig_(0);
		synth.set(\t_trig, this.trig);
	}
	
}

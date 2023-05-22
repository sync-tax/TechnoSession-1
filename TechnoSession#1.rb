use_bpm 126
use_debug false

#MIXER
master = 1

synth_amp = 0.0
synth2_amp = 0.02
slicer_amp = 0

atmo_amp = 0.3

kick_amp = 0
bass_amp = 0.0
drum1_amp = 0.4
drum2_amp = 0.0
drum3_amp = 0
hat_amp = 0.0
thingy_amp = 0

#SAMPS
s = "/Users/rober/Documents/samples/acidgurkal/"

#LOOPS

live_loop :bassline do
  bass_co = range(65, 70, 0.25).mirror
  sleep 1
  with_fx :eq, low_shelf: -0.5 do#-3, 0.35
    sample s, 1,
      decay: 0.1,
      release: 0.25,
      attack: 0.015,
      sustain: 0.0001,
      cutoff:  bass_co.look, # 50, bass_co.look
      amp: bass_amp * master, #* kick_rhythm.tick
      beat_stretch: 2, #2, 3
      rate: 1
  end
end

live_loop :kick do
  with_fx :eq, low_shelf: -0.15, low: -0.15 do
    sleep 0.5
    sample s, 0,
      amp: kick_amp  * $kick_rhythm.tick,
      beat_stretch: 1.25,
      cutoff: 80
  end
end

live_loop :drum1 do
  with_fx :ping_pong, feedback: 0.9  do
    with_fx :gverb, dry: 1, release: 0.2 do
      sample s, 2,
        amp: drum1_amp * master,
        beat_stretch: 0.3,
        rate: 2, # 1,25 & 0.5
        cutoff: 80
      sleep 4
    end
  end
end

live_loop :drum2 do
  with_fx :gverb, dry: 1, release: 0.2 do
    sleep 4
    sample  s, 3,
      amp: drum2_amp * master,
      beat_stretch: 0.35,
      cutoff: 80
  end
end

live_loop :drum3 do
  with_fx :reverb, mix: 0.15 do
    with_fx :slicer, phase: 0.5 do
      sample  s, 2,
        amp: drum3_amp * master,
        rate: (ring,  -1.25).tick, #(ring, -1.25, 8).tick
        cutoff: 90,
        release: 0.3
      sleep 2
    end
  end
end

live_loop :hihat, sync: :bassline do
  with_fx :gverb, dry: 1, release: 0.25 do
    with_fx :reverb, mix: 0.25, room: 0.37 do
      sample s, 4, amp: hat_amp * master, rate: 8, cutoff: 80
      sleep 0.5
      sample s, 4, amp: hat_amp * master, rate: 6, cutoff: 100
      sleep 0.5
      sample s, 4, amp: hat_amp * master, rate: 10, cutoff: 90
      sleep 0.5
      sample :drum_cymbal_closed, amp: hat_amp * master, rate: 12, cutoff: 100
      sleep 2.5 # 2.5
    end
  end
end

live_loop :coolthingy do
  with_fx :gverb, release: 2 do #2 & 0.25
    with_fx :ping_pong, phase: 0.5 , feedback: 0.8 do
      sample  s, 6,
        amp: thingy_amp * master,
        beat_stretch: (ring 1, 1.25).tick,
        rate: 1, #1 & 1.15
        cutoff: 100,
        pitch: -8
      sleep 8
    end
  end
end

live_loop :atmo do
  #stop
  with_fx :echo, phase: 4 do
    sample :ambi_soft_buzz,
      amp: atmo_amp * master,
      beat_stretch: 42,
      rate: (ring 3, 4).tick,
      pitch: 14 #1, 8, 14
    sleep 8
  end
end

live_loop :slicer do
  #stop
  with_fx :reverb, mix: 0.6, room: 0.75 do
    with_fx :panslicer, phase: 0.5 do
      synth_co = range(70, 75, 2.5).mirror
      sample s, 7,
        amp: slicer_amp * master,
        rate: 1.0,
        beat_stretch: 4,
        release: 0.25,
        attack: 0.05,
        cutoff: synth_co.look,
        pitch: 10,
        pan:  (ring , 1, -1, -1, 1).tick
      sleep 2
    end
  end
end

live_loop :synth do
  #stop
  with_synth :pretty_bell  do
    with_fx :reverb, mix: 0.5, room: 0.75 do
      with_fx :flanger, feedback: 0.75 do
        use_random_seed (ring, 12, 10, 12).tick
        8.times do
          n = (ring :d3, :f2, chord(:G, :major7), :a3).choose
          play scale(n, :bartok).choose,
            release: (ring 0.15, 0.1, 0.15,  0.1).tick,
            amp: synth_amp * master,
            pitch: -2
          sleep 0.5
        end
      end
    end
  end
end

live_loop :synth3 do
  stop
  with_fx :gverb, dry: 10, release: 0.35 do
    with_fx :reverb, room: 0.6, mix: 0.5 do
      use_random_seed (ring, 18, 110, 112).tick #(ring, 18, 110, 112).tick
      4.times do
        with_synth :tb303 do #dull bell & dark amb
          synth_co = range(65, 72, 0.5).mirror
          n = (ring :f2, :g2, :e1, :d2).choose #(ring :f6, :g3, :e2, :d3)
          play scale(n, :bartok).choose,
            release: (ring 0.5, 0.15, 0.8, 0.18).tick,
            cutoff: synth_co.look,
            res: 0.8,
            wave: 0,
            amp: synth2_amp * master,
            pitch: 8
          sleep 0.5
        end
        sleep 0.0
      end
    end
  end
end
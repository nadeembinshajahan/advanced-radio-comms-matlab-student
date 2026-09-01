# Advanced Radio Communications — Student MATLAB Exercises

## Quick start

Paste this one line into MATLAB or MATLAB Online and press Enter:

```matlab
websave('setup.m','https://raw.githubusercontent.com/nadeembinshajahan/advanced-radio-comms-matlab-student/main/setup.m'); setup
```

It downloads the exercises and the sample data into the folder you are currently in.

Student starter exercises for Days 1–5 of the Advanced Radio Communications course. Each script contains guided sections and clearly marked `YOUR CODE HERE` portions for students to complete.

## Getting started

1. Open the required `.m` file in MATLAB or MATLAB Online.
2. Work through the script one section at a time. Section headings begin with `%%`.
3. Fill in each `YOUR CODE HERE` line before running that section.
4. Read the plot labels and command-window prompts, then try the suggested one-number variations.

These exercises do not require Pluto SDR hardware. The real-spectrum exercise works from a capture file supplied in `data/`, so it runs anywhere. Instructor solutions and trainer guides are intentionally not included.

## Exercise map

### Day 1 — Wireless foundations

- dB and dBm warm-up
- Frequency and wavelength
- First sampled signal and spectrum
- Mixer sum and difference frequencies
- Signal regeneration
- Real spectrum from a captured signal (`ex6_real_spectrum_student.m`)
- Spectrum challenges — open-ended measurement problems with built-in hints and self-checks (`ex6_challenges.m`)

`ex6_real_spectrum_student.m` and `ex6_challenges.m` also appear under `day02/`. **`day02/` is the canonical location** — the real-spectrum exercise belongs to Day 2. The `day01/` copies are kept in place, unchanged, because links to them are already in circulation.

### Day 2 — RF waves and transmission lines

- Reflection coefficient and VSWR
- Mismatch loss
- Polarization mismatch
- Standing waves
- Wave behavior and path loss
- Real spectrum from a captured signal (`ex6_real_spectrum_student.m`)
- Spectrum challenges — open-ended measurement problems, with progressive hints and answer checking built in (`ex6_challenges.m`, `hint.m`, `selfcheck.m`)

### Day 3 — Analog and digital modulation

- AM built from first principles
- AM spectrum
- FM and Carson's rule
- BPSK and QPSK
- Noisy constellations

### Day 4 — Receiver building blocks

- Cascaded gain and loss budget
- Receiver noise figure
- Filter response
- Mixer and IF planning

### Day 5 — Antennas and link budgets

- Antenna gain
- Radiation patterns
- End-to-end link budget

## Challenge problems

`day02/ex6_challenges.m` is a set of open-ended problems built on the same captures: six core challenges plus one optional stretch challenge. They are questions, not procedures — you are given the goal and you work out the method. Several have no single right answer. Allow about two hours for the six; the stretch one is extra.

They are designed to be done on your own. Two helpers sit alongside the file, and nothing is printed until you ask for it, so you cannot spoil a challenge by reading the code.

| Type this | What happens |
| --- | --- |
| `hint(2)` | The first hint for Challenge 2. Call it again for the next one. |
| `hint(2,'reset')` | Start that challenge's hints again from the beginning. |
| `selfcheck(2, myValue)` | Checks your number and tells you whether it is right, close, or wrong in a way it recognises. |

There are three hints per challenge and they get more specific: the first reframes the question, the second names the method, the third gives you the shape of the calculation. None of them gives you the answer.

`selfcheck` never prints the correct value either. When it recognises a common mistake it names it — for example, it can tell when a signal level came from reading a single FFT point rather than measuring the whole channel, and it will say so and send you back to try a different number of samples. On the judgement questions, where there is no single right number, it asks you questions instead and tells you what a good answer has to account for.

Every challenge also carries a short "you are done when..." list and a time estimate, so you can tell when to stop without asking anybody.

## Exploring further

The `day01/explore*.m` scripts are not exercises. Each one is short, complete and runnable, and shows a single idea you can change and re-run to build intuition. Every script ends with a `TRY THIS` block suggesting two or three experiments and what you should expect to see.

| Script | What it shows |
| --- | --- |
| `explore01_resolution.m` | How the number of samples you use sets your frequency resolution |
| `explore02_windowing.m` | Why a window helps, and what spectral leakage looks like without one |
| `explore03_zoom_station.m` | Zooming in on one station to see its shape and width |
| `explore04_iq_time.m` | What I and Q actually look like in the time domain |
| `explore05_gain_noise_floor.m` | How receiver gain moves the noise floor |
| `explore06_relative_power.m` | Measuring the difference between two signals in dB |

## Sample data

`data/` holds two captures of the FM broadcast band centred on 98 MHz, one at high receiver gain and one at low gain, in the same format a radio would produce. Load one with `load('data/fm_capture_98MHz.mat')` to get the complex samples plus the sample rate and centre frequency.

`make_synthetic_capture.m` regenerates these files. To use your own recording instead, save your samples in the same format and point the scripts at your file.

## Repository contents

Only student-facing starter scripts, exploration scripts, sample data and the `setup.m` downloader are included. Filenames ending in `_student.m` are intended for classroom use and independent practice.

Copyright © 2026 Beacon Red Investment – Sole Proprietorship LLC. All rights reserved.

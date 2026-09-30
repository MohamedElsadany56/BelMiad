"""Generates the reminder tones bundled in android/app/src/main/res/raw.

The tones are synthesised here (no third-party audio), so they can be
regenerated or tweaked at any time:

    py tool/generate_tones.py
"""
import math
import os
import struct
import wave

RATE = 22050
OUT = os.path.join(os.path.dirname(__file__), '..', 'android', 'app', 'src',
                   'main', 'res', 'raw')


def note(freq, start, length, partials, decay, volume=1.0):
    """A struck note: harmonic partials with an exponential decay."""
    return (freq, start, length, partials, decay, volume)


def render(notes, total):
    samples = [0.0] * int(RATE * total)
    for freq, start, length, partials, decay, volume in notes:
        first = int(start * RATE)
        count = int(length * RATE)
        for i in range(count):
            t = i / RATE
            attack = min(1.0, t / 0.005)  # 5 ms attack, no clicks
            env = attack * math.exp(-decay * t) * volume
            value = sum(amp * math.sin(2 * math.pi * freq * ratio * t)
                        for ratio, amp in partials)
            if first + i < len(samples):
                samples[first + i] += value * env
    # Fade the tail and normalise to -3 dB.
    tail = int(0.05 * RATE)
    for i in range(tail):
        samples[-1 - i] *= i / tail
    peak = max(abs(s) for s in samples) or 1.0
    return [s / peak * 0.7 for s in samples]


def save(name, samples):
    path = os.path.join(OUT, name + '.wav')
    with wave.open(path, 'wb') as out:
        out.setnchannels(1)
        out.setsampwidth(2)
        out.setframerate(RATE)
        out.writeframes(b''.join(
            struct.pack('<h', int(max(-1, min(1, s)) * 32767))
            for s in samples))
    print('wrote', os.path.normpath(path))


BELL = [(1, 1.0), (2.0, 0.5), (3.0, 0.25), (4.2, 0.12)]
SOFT = [(1, 1.0), (2, 0.2), (3, 0.05)]
MARIMBA = [(1, 1.0), (4, 0.3), (10, 0.05)]

# Chime: a rising C-E-G arpeggio.
save('belmiad_chime', render([
    note(1046.5, 0.00, 1.2, BELL, 3.5),
    note(1318.5, 0.16, 1.2, BELL, 3.5),
    note(1568.0, 0.32, 1.3, BELL, 3.0),
], 1.7))

# Bell: one clear strike with slightly inharmonic overtones.
save('belmiad_bell', render([
    note(880.0, 0.0, 2.0, [(1, 1.0), (2.76, 0.45), (5.4, 0.2), (8.9, 0.08)], 2.2),
], 2.0))

# Gentle: two soft marimba notes.
save('belmiad_gentle', render([
    note(659.3, 0.00, 0.8, MARIMBA, 6.0),
    note(987.8, 0.22, 1.0, MARIMBA, 5.0),
], 1.3))

# Alert: three short, clear beeps for people who miss softer sounds.
save('belmiad_alert', render([
    note(1760.0, start, 0.16, SOFT, 12.0)
    for start in (0.0, 0.22, 0.44)
] + [note(2093.0, 0.66, 0.3, SOFT, 8.0)], 1.1))

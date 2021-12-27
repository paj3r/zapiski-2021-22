import math

import numpy as np
import pretty_midi
import numpy
import pygame
import mir_eval.display
import librosa.display
import matplotlib.pyplot as plt
from tkinter import *
import os


def play_music(music_file, pm, chords):
    """
    stream music with mixer.music module in blocking manner
    this will stream the sound from disk while playing
    """
    count = 0
    dbs = get_2nd_beats(pm)
    clock = pygame.time.Clock()
    try:
        pygame.mixer.music.load(music_file)
        print("Music file %s loaded!" % music_file)
    except pygame.error:
        print("File %s not found! (%s)" % (music_file, pygame.get_error()))
        return
    pygame.mixer.music.play()
    while pygame.mixer.music.get_busy():
        # check if playback has finished
        if pygame.time.get_ticks() >= (dbs[count] * 1000):
            print(chords[count])
            count += 1
        clock.tick(30)


# pick a midi music file you have ...
# (if not in working folder use full path)

major_krumhansl = [6.35, 2.23, 3.48, 2.33, 4.38, 4.09, 2.52, 5.19, 2.39, 3.66, 2.29, 2.88]
major_krumhansl = numpy.asarray(major_krumhansl) / sum(major_krumhansl)
minor_krumhansl = [6.33, 2.68, 3.52, 5.38, 2.60, 3.53, 2.54, 4.75, 3.98, 2.69, 3.34, 3.17]
minor_krumhansl = numpy.asarray(minor_krumhansl) / sum(minor_krumhansl)
major_keys = ["C", "Db", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"]
minor_keys = ["c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "b"]


def fit_to_key_Krumhansl(midi):
    freqs = midi.get_pitch_class_histogram(use_duration=True)
    freqs = np.concatenate((freqs, freqs))
    major = True
    min = 1000
    ix = 0
    for i in range(12):
        diff = 0
        for j in range(12):
            diff += abs(major_krumhansl[j] - freqs[i + j])
        if diff < min:
            ix = i
            major = True
            min = diff
        diff = 0
        for j in range(12):
            diff += abs(minor_krumhansl[j] - freqs[i + j])
        if diff < min:
            ix = i
            major = False
            min = diff
    if major:
        return major_keys[ix]
    else:
        return minor_keys[ix]


def get_pitch_class_histogram_improved(self, start_time, end_time, use_duration=True,
                                       use_velocity=False, normalize=True):
    # Return all zeros if track is drum
    if self.is_drum:
        return np.zeros(12)

    weights = np.ones(len(self.notes))

    # Assumes that duration and velocity have equal weight
    if use_duration:
        # weights *= [note.end - note.start for note in self.notes]
        weights = []
        for note in self.notes:
            if start_time <= note.start <= end_time or start_time <= note.end <= end_time:
                weights.append(note.end - note.start)
    if use_velocity:
        # weights *= [note.velocity for note in self.notes]
        weights = []
        for note in self.notes:
            if start_time <= note.start <= end_time or start_time <= note.end <= end_time:
                weights.append(note.velocity)

    hist = []
    for n in self.notes:
        if start_time <= n.start <= end_time or start_time <= n.end <= end_time:
            hist.append(n.pitch % 12)
    histogram, _ = np.histogram(hist,
                                bins=np.arange(13),
                                weights=weights,
                                density=normalize)
    histogram[np.isnan(histogram)] = 0

    return histogram


def get_pitch_class_histogram_everynote(self, start_time, end_time, use_duration=True,
                                        use_velocity=False, normalize=True):
    # Return all zeros if track is drum
    if self.is_drum:
        return np.zeros(128)

    weights = np.ones(len(self.notes))

    # Assumes that duration and velocity have equal weight
    if use_duration:
        # weights *= [note.end - note.start for note in self.notes]
        weights = []
        for note in self.notes:
            if start_time <= note.start <= end_time or start_time <= note.end <= end_time:
                weights.append(note.end - note.start)
    if use_velocity:
        # weights *= [note.velocity for note in self.notes]
        weights = []
        for note in self.notes:
            if start_time <= note.start <= end_time or start_time <= note.end <= end_time:
                weights.append(note.velocity)

    hist = []
    for n in self.notes:
        if start_time <= n.start <= end_time or start_time <= n.end <= end_time:
            hist.append(n.pitch)
    histogram, _ = np.histogram(hist,
                                bins=np.arange(129),
                                weights=weights,
                                density=normalize)
    histogram[np.isnan(histogram)] = 0

    return histogram


def get_pitch_class_histogram_all_inst(self, start_time, end_time, use_duration=True,
                                       use_velocity=False, normalize=True, all_notes=False):
    # Sum up all histograms from all instruments defaulting to np.zeros(12)
    if all_notes:
        histogram = sum([get_pitch_class_histogram_everynote(i, start_time, end_time)
                         for i in self.instruments], np.zeros(128))
    else:
        histogram = sum([get_pitch_class_histogram_improved(i, start_time, end_time)
                         for i in self.instruments], np.zeros(12))

    # Normalize accordingly
    if normalize:
        histogram /= (histogram.sum() + (histogram.sum() == 0))

    return histogram


def get_chord_array_naive(pm):
    dbs = get_2nd_beats(pm)
    arr = []
    for i in range(0, len(dbs) - 1):
        hist = get_pitch_class_histogram_all_inst(pm, dbs[i], dbs[i + 1])
        print(hist)
        arr.append(major_keys[np.argmax(hist)])
    return arr


def get_chord_array_bass_only(pm):
    dbs = get_2nd_beats(pm)
    arr = []
    for i in range(0, len(dbs) - 1):
        hist = get_pitch_class_histogram_all_inst(pm, dbs[i], dbs[i + 1], all_notes=True)
        ix = 0
        for j in range(1, 60):
            if hist[j] > hist[ix]:
                ix = j
        arr.append(major_keys[ix % 12])
    return arr


def get_chord_array_chord(pm):
    dbs = get_2nd_beats(pm)
    arr = []
    max = 0
    ix = 0
    major = True
    for i in range(0, len(dbs) - 1):
        hist = get_pitch_class_histogram_all_inst(pm, dbs[i], dbs[i + 1])
        hist = np.concatenate((hist, hist))
        max = 0
        for j in range(12):
            sum = 0
            sum += hist[j]
            sum += hist[j + 4]
            sum += hist[j + 7]
            if max < sum:
                ix = j
                max = sum
                major = True
            sum = 0
            sum += hist[j]
            sum += hist[j + 3]
            sum += hist[j + 7]
            if max < sum:
                ix = j
                max = sum
                major = False
            print(str(max) + ", " + str(sum))
        if major:
            arr.append(major_keys[ix] + " dur")
        else:
            arr.append(major_keys[ix] + " mol")
        print("novapls \n")
    return arr


def get_chord_array_bass_chord(pm):
    dbs = get_2nd_beats(pm)
    arr = []
    for i in range(0, len(dbs) - 1):
        hist = get_pitch_class_histogram_all_inst(pm, dbs[i], dbs[i + 1], all_notes=True)
        ix = 0
        max = 0
        major = True
        for j in range(21, 60):
            suma = 0
            minsuma = 0
            for g in range(j, 120, 12):
                suma += hist[g]
                suma += hist[g + 4]
                suma += hist[g + 7]
                minsuma += hist[g]
                minsuma += hist[g + 3]
                minsuma += hist[g + 7]
            if minsuma > suma:
                if minsuma > max:
                    ix = j
                    max = minsuma
                    major = False
            else:
                if suma > max:
                    ix = j
                    max = suma
                    major = True
        if max > 0:
            if major:
                arr.append(major_keys[ix % 12])
            else:
                arr.append(major_keys[ix % 12] + "m")
        else:
            arr.append("Null")
    return arr


def my_get_dbeats(pm):
    dbs = pm.get_downbeats()
    strt = pm.estimate_beat_start()
    ix = np.where(dbs == strt)
    return dbs[ix[0][0]:]


def get_2nd_beats(pm):
    bs = pm.get_beats()
    return bs[::2]

class MusicPlayer:

    # Defining Constructor
    def __init__(self, root):
        self.chords = []
        self.dbs = []
        self.count = 0
        self.clock = None
        self.key = None
        self.root = root
        self.paused = False
        # Title of the window
        self.root.title("Music Player")
        # Window Geometry
        self.root.geometry("1000x200+200+200")
        # Initiating Pygame
        pygame.init()
        # Initiating Pygame Mixer
        pygame.mixer.init()
        # Declaring track Variable
        self.keysng = StringVar()
        # Declaring Status Variable
        self.curchr = StringVar()

        self.nxtchr = StringVar()

        # Creating Track Frame for Song label & status label
        keyframe = LabelFrame(self.root, text="Song key", font=("times new roman", 12, "bold"), bg="grey",
                                fg="white", bd=5, relief=GROOVE)
        keyframe.place(x=0, y=0, width=200, height=100)
        curframe = LabelFrame(self.root, text="Current chord", font=("times new roman", 12, "bold"), bg="grey",
                                fg="white", bd=5, relief=GROOVE)
        curframe.place(x=200, y=0, width=200, height=100)
        nextframe = LabelFrame(self.root, text="Next chord", font=("times new roman", 12, "bold"), bg="grey",
                                fg="white", bd=5, relief=GROOVE)
        nextframe.place(x=400, y=0, width=200, height=100)
        # Inserting Song Track Label
        keytrack = Label(keyframe, textvariable=self.keysng, width=9, font=("times new roman", 24, "bold"),
                          bg="grey", fg="gold").grid(row=0, column=0, padx=6, pady=5)
        curtrack = Label(curframe, textvariable=self.curchr, width=9, font=("times new roman", 24, "bold"),
                         bg="grey", fg="gold").grid(row=0, column=0, padx=6, pady=5)
        nexttrack = Label(nextframe, textvariable=self.nxtchr, width=9, font=("times new roman", 24, "bold"),
                         bg="grey", fg="gold").grid(row=0, column=0, padx=6, pady=5)

        # Creating Button Frame
        buttonframe = LabelFrame(self.root, text="Control Panel", font=("times new roman", 15, "bold"), bg="grey",
                                 fg="white", bd=5, relief=GROOVE)
        buttonframe.place(x=0, y=100, width=600, height=100)
        # Inserting Play Button
        playbtn = Button(buttonframe, text="PLAY", command=self.playsong, width=6, height=1,
                         font=("times new roman", 16, "bold"), fg="navyblue", bg="gold").grid(row=0, column=0, padx=10,
                                                                                              pady=5)
        # Inserting Pause Button
        playbtn = Button(buttonframe, text="PAUSE", command=self.pausesong, width=8, height=1,
                         font=("times new roman", 16, "bold"), fg="navyblue", bg="gold").grid(row=0, column=1, padx=10,
                                                                                              pady=5)
        # Inserting Unpause Button
        playbtn = Button(buttonframe, text="UNPAUSE", command=self.unpausesong, width=10, height=1,
                         font=("times new roman", 16, "bold"), fg="navyblue", bg="gold").grid(row=0, column=2, padx=10,
                                                                                              pady=5)
        # Inserting Stop Button
        playbtn = Button(buttonframe, text="STOP", command=self.stopsong, width=6, height=1,
                         font=("times new roman", 16, "bold"), fg="navyblue", bg="gold").grid(row=0, column=3, padx=10,
                                                                                              pady=5)

        # Creating Playlist Frame
        songsframe = LabelFrame(self.root, text="Song Playlist", font=("times new roman", 15, "bold"), bg="grey",
                                fg="white", bd=5, relief=GROOVE)
        songsframe.place(x=600, y=0, width=400, height=200)
        # Inserting scrollbar
        scrol_y = Scrollbar(songsframe, orient=VERTICAL)
        # Inserting Playlist listbox
        self.playlist = Listbox(songsframe, yscrollcommand=scrol_y.set, selectbackground="gold", selectmode=SINGLE,
                                font=("times new roman", 12, "bold"), bg="silver", fg="navyblue", bd=5, relief=GROOVE)
        # Applying Scrollbar to listbox
        scrol_y.pack(side=RIGHT, fill=Y)
        scrol_y.config(command=self.playlist.yview)
        self.playlist.pack(fill=BOTH)
        # Changing Directory for fetching Songs
        os.chdir("./Midis")
        # Fetching Songs
        songtracks = os.listdir()
        # Inserting Songs into Playlist
        for track in songtracks:
            self.playlist.insert(END, track)

    # Defining Play Song Function
    def playsong(self):
        pm = pretty_midi.PrettyMIDI(self.playlist.get(ACTIVE))
        self.chords = get_chord_array_bass_chord(pm)
        print(self.chords)
        self.key = fit_to_key_Krumhansl(pm)
        self.dbs = get_2nd_beats(pm)
        self.count = 0
        # Displaying Selected Song title
        self.keysng.set(self.key)
        # Loading Selected Song
        pygame.mixer.music.load(self.playlist.get(ACTIVE))
        # Playing Selected Song
        self.paused = False
        pygame.mixer.music.play()

    def stopsong(self):
        # Displaying Status
        self.keysng.set("")
        self.nxtchr.set("")
        self.curchr.set("")
        # Stopped Song
        self.paused = False
        pygame.mixer.music.stop()

    def pausesong(self):
        # Displaying Status
        # Paused Song
        self.paused = True
        pygame.mixer.music.pause()

    def unpausesong(self):
        # Displaying Status
        # Playing back Song
        self.paused = False
        pygame.mixer.music.unpause()

# pm = pretty_midi.PrettyMIDI(self.playlist.get(ACTIVE))
# print(get_2nd_beats(pm))
# chords = get_chord_array_bass_chord(pm)
# fit_to_key_Krumhansl(pm)
# Creating TK Container
root = Tk()
# Passing Root to MusicPlayer Class
mp = MusicPlayer(root)
# Root Window Looping
while True:
    while pygame.mixer.music.get_busy():
        # check if playback has finished
        dbs = mp.dbs
        count = mp.count
        chords = mp.chords
        if count <= len(chords):
            if pygame.mixer.music.get_pos() >= ((dbs[count] * 1000)+500):
                if count > len(chords)-1:
                    mp.curchr.set("end")
                else:
                    mp.curchr.set(chords[count])
                if count >= len(chords)-1:
                    mp.nxtchr.set("end")
                else:
                    mp.nxtchr.set(chords[count+1])
                mp.count += 1
        root.update_idletasks()
        root.update()
    if not mp.paused:
        mp.curchr.set("")
        mp.nxtchr.set("")
        mp.keysng.set("")
    root.update_idletasks()
    root.update()
    # while pygame.mixer.music.get_busy():
    #     # check if playback has finished
    #     if pygame.time.get_ticks() >= (dbs[count]*1000):
    #         print(chords[count])
    #         count += 1
    #     clock.tick(30)

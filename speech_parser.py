from AnvilParser import AnvilParser
import csv

FPS = 25

data_folder = 'speech/'
folders = [
    'C_01_FF_01_02',
    'C_02_FM_01_03',
    'C_03_FF_04_02',
    'C_04_FF_04_05',
    'C_05_FF_06_05',
    'C_06_FF_06_07',
    'C_07_MF_08_07',
    'C_08_MM_08_09',
    'C_09_MM_03_09',
    'C_10_FM_10_11',
    'C_11_FM_10_12',
    'C_12_MM_13_12',
    'C_13_MM_13_11',
    'C_14_MM_16_14',
    'C_15_MM_15_14',
    'C_16_MM_15_16',
    'C_17_FF_17_18',
    'C_18_FF_19_18',
    'C_19_FF_19_20',
    'C_20_MF_21_20',
    'C_21_MM_21_22',
    'C_22_MM_23_22',
    'C_23_MF_23_17'
]

# trying use a simpley way to classify given string is a meaningful word or not
def is_word(words):
    # if containing spaces, there are more than one word
    if ' ' in words:
        return True

    ok_words = ['i', 'no', 'so', 'or', 'it', 'if', 'my', 'he', 'yes', 'but', 'the', 'how']
    not_words = ['yeah', 'uhuh', 'aand', 'mhmm', 'ummm', 'uuhh', '*tsk*']

    if len(words) < 4 and not words in ok_words:
        return False

    if len(words) == 4 and words in not_words:
        return False

    if words[0] in ['-', '[', '*']:
        return False

    return True


def export2csv(data, ofilename, corpus):
    csvfile = open(ofilename, 'wb')
    csvwriter = csv.writer(csvfile)

    for row in data:
        words = row['words'].lower().strip()
        if not corpus.has_key(words):
            corpus[words] = 1
        else:
            corpus[words] += 1
        if words == '*laugh*' or words == '*naer*':
            text = 1
        elif words == '*small laugh*':
            text = 2
        elif not is_word(words):
            text = 3
        else:
            text = 0

        start = int(float(row['start']) * FPS)
        end = int(float(row['end']) * FPS)
        csvwriter.writerow([start, end, text])

def export_corpus(corpus):
    csvfile = open('corpus.csv', 'wb')
    csvwriter = csv.writer(csvfile)
    for key in corpus.keys():
        csvwriter.writerow([key.encode('utf8'), corpus[key]])

if __name__ == '__main__':
    parser = AnvilParser()
    tfolders = folders
    corpus = {}
    for folder in tfolders:
        ifilename = 'anvil/' + folder + '.anvil'
        print ifilename
        for side in ['SpeakerLeft', 'SpeakerRight']:
            speech = parser.getSpeech(ifilename, side)
            ofilename = 'speech/' + folder + '_' + side + '.csv'
            export2csv(speech, ofilename, corpus)

    # export_corpus(corpus)
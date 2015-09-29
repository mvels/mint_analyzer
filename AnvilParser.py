import xml.etree.ElementTree as ET

class AnvilParser(object):
    def __init__(self):
        pass

    def getAnnotationTracks(self, filename):
        tree = ET.parse(filename)
        root = tree.getroot()
        body = root.find('body')
        tracks = body.findall('track')
        return tracks

    def getHandGestures(self, filename):
        handGestures = []
        for track in self.getAnnotationTracks(filename):
            if 'HandGesture' in track.get('name'):
                print track.get('name')
                for gesture in track.findall('el'):
                    handGestures.append({'start': gesture.get('start'), 'end': gesture.get('end')})
        return handGestures

    def getSpeech(self, ifilename, side = 'SpeakerLeft'):
        speech = []
        for track in self.getAnnotationTracks(ifilename):
            if side + '.Transl' in track.get('name'):
                print track.get('name')
                for gesture in track.findall('el'):
                    for attribute in gesture.findall('attribute'):
                        words = attribute.text
                        if words == '[...]':
                            continue
                        speech.append({'start': gesture.get('start'), 'end': gesture.get('end'), 'words': words})

        return speech

if __name__ == '__main__':
    parser = AnvilParser()
    left_speech = parser.getSpeech('anvil/C_01_FF_01_02.anvil', 'SpeakerLeft')
    right_speech = parser.getSpeech('anvil/C_01_FF_01_02.anvil', 'SpeakerRight')
    print left_speech
    print right_speech
import cv2
import time
import sys
import numpy as np
import csv

FRAME_STEP = 500
HEAD_HEIGHT = 50
DATA_COLUMNS = 33
MIN_PERSON_AREA = 2000
MIN_HEAD_AREA = 50
MIN_BODY_AREA = 100
MIN_LEG_AREA = 100
COLOR_BLUE = (255, 0, 0)
COLOR_GREEN = (0, 255, 0)

video_folder = '/Users/martin/phd_videos/'
data_folder = 'data/'
folders = [
    '01_FF_01_02',
    '02_FM_01_03',
    '03_FF_04_02',
    '04_FF_04_05',
    '05_FF_06_05',
    '06_FF_06_07',
    '07_MF_08_07',
    '08_MM_08_09',
    '09_MM_03_09',
    '10_FM_10_11',
    '11_FM_10_12',
    '12_MM_13_12',
    '13_MM_13_11',
    '14_MM_16_14',
    '15_MM_15_14',
    '16_MM_15_16',
    '17_FF_17_18',
    '18_FF_19_18',
    '19_FF_19_20',
    '20_MF_21_20',
    '21_MM_21_22',
    '22_MM_23_22',
    '23_MF_23_17'
]


def button_pressed():
    keycode = cv2.waitKey(1)
    if keycode != -1:
        keycode &= 0xff
    return keycode != -1


def extract_first_frame(ifilename, ofilename):
    videoCapture = cv2.VideoCapture(ifilename)
    success, frame = videoCapture.read()
    frame_gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    cv2.imwrite(ofilename, frame_gray)


def extract_random_frame(ifilename, folder):
    videoCapture = cv2.VideoCapture(ifilename)
    if (not videoCapture.isOpened()):
        print "video not opened"
        return

    total_frames = int(videoCapture.get(cv2.cv.CV_CAP_PROP_FRAME_COUNT))
    print total_frames

    frame_count = 0
    for position in xrange(1000, total_frames, FRAME_STEP):
        frame_count += 1
        videoCapture.set(cv2.cv.CV_CAP_PROP_POS_FRAMES, position)
        success, frame = videoCapture.read()
        if success:
            print position
            frame_gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            ofname = 'objects/C_' + folder + '_' + str(frame_count) + '.png'
            cv2.imwrite(ofname, frame_gray)
            # cv2.imshow('Random frame', frame_gray)

            # cv2.imwrite(ofilename, frame_gray)

def extract_frame(ifilename, ofilename, frameNumber):
    videoCapture = cv2.VideoCapture(ifilename)
    if (not videoCapture.isOpened()):
        print "video not opened"
        return

    total_frames = int(videoCapture.get(cv2.cv.CV_CAP_PROP_FRAME_COUNT))

    videoCapture.set(cv2.cv.CV_CAP_PROP_POS_FRAMES, frameNumber)
    success, frame = videoCapture.read()
    if success:
        print "Frame {} successfully extracted".format(frameNumber)
        # frame_gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        cv2.imwrite(ofilename + '.png', frame)

def extract_first_frame_from_all_videos():
    for folder in folders:
        ifname = video_folder + folder + '/C_' + folder + '.avi'
        ofname = 'img/C_' + folder + '.png'
        print ifname
        extract_first_frame(ifname, ofname)


def extract_random_frame_from_all_videos():
    # tfolders = [folders[0]]
    tfolders = folders
    for folder in tfolders:
        ifname = video_folder + folder + '/C_' + folder + '.avi'
        ofname = 'img/C_' + folder + '.png'
        print ifname
        extract_random_frame(ifname, folder)


def shift_array(iarray, step):
    narray = np.zeros_like(iarray) + iarray
    # down
    narray[step:, :] += iarray[0:-step, :]
    # up
    narray[:-step, :] += iarray[step:, :]
    # right
    narray[:, step:] += iarray[:, 0:-step]
    # left
    narray[:, :-step] += iarray[:, step:]
    narray[narray > 0] = 255
    return narray


def find_contours(image, min_area):
    contours, hierarchy = cv2.findContours(image.copy(), cv2.RETR_CCOMP, cv2.CHAIN_APPROX_SIMPLE)
    # contours, hierarchy = cv2.findContours(image.copy(), cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    boxes = []
    contours = sorted(contours, key=cv2.contourArea, reverse=True)[:2]
    for idx, contour in enumerate(contours):
        c_area = cv2.contourArea(contour)
        if c_area > min_area:
            x, y, w, h = cv2.boundingRect(contour)

            # avoiding boxes inside boxes
            add_box = True
            for box in boxes:
                if x >= box[0] and x + w <= box[0] + box[2]:
                    add_box = False
                    break
            if not add_box:
                continue

            boxes.append([x, y, w, h])

    return boxes


def bgsubtract(ifilename, ofilename, targetFrame=1):
    videoCapture = cv2.VideoCapture(ifilename)
    if (not videoCapture.isOpened()):
        print "video not opened"
        return

    if targetFrame == 1:
        csvfile = open(ofilename, 'wb')
        csvwriter = csv.writer(csvfile)

    fps = videoCapture.get(cv2.cv.CV_CAP_PROP_FPS)
    frames_total = int(videoCapture.get(cv2.cv.CV_CAP_PROP_FRAME_COUNT))
    frame_width = int(videoCapture.get(cv2.cv.CV_CAP_PROP_FRAME_WIDTH))
    frame_height = int(videoCapture.get(cv2.cv.CV_CAP_PROP_FRAME_HEIGHT))
    frame_middle = frame_width / 2
    min_head_pos = frame_height / 2

    hyster_lo = 25
    hyster_hi = 50

    kernel = np.ones((3, 3), np.uint8)
    ret, frame = videoCapture.read()
    bgframe = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    bgedges = cv2.Canny(bgframe, hyster_lo, hyster_hi)
    bgedges = shift_array(bgedges, 1)

    # skip first n frames
    frame_count = targetFrame
    videoCapture.set(cv2.cv.CV_CAP_PROP_POS_FRAMES, frame_count)
    first = True
    last_done = -1

    while (True):
        windows = []
        ret, frame = videoCapture.read()
        if not ret:
            break

        gframe = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        edges = cv2.Canny(gframe, hyster_lo, hyster_hi)

        subtracted = edges.astype(int) - bgedges.astype(int)
        subtracted[subtracted < 0] = 0
        subtracted = subtracted.astype(np.uint8)
        closed = cv2.morphologyEx(subtracted, cv2.MORPH_CLOSE, kernel, iterations=5)

        boxes = find_contours(closed, MIN_PERSON_AREA)
        heads = np.zeros_like(subtracted)
        bodys = np.zeros_like(subtracted)
        legs = np.zeros_like(subtracted)
        seg_data = np.zeros(DATA_COLUMNS, np.int)
        seg_data[0] = frame_count

        seg_data = add_boxes_data(seg_data, boxes, frame_middle, 'person')
        for box in boxes:
            x, y, w, h = box
            cv2.rectangle(frame, (x, y), (x + w, y + (frame_height - y)), COLOR_BLUE, 2)

            border = 10
            if x > 0 and y > 0 and x + w < frame_width and y + HEAD_HEIGHT < min_head_pos:
                heads[y:y + HEAD_HEIGHT, x - border:x + w + border] = subtracted[y:y + HEAD_HEIGHT,
                                                                      x - border:x + w + border]
                body_y = y + HEAD_HEIGHT
                body_height = (frame_height - body_y) / 2
                bodys[body_y:body_y + body_height, x - border:x + w + border] = subtracted[body_y:body_y + body_height,
                                                                                x - border:x + w + border]
                legs_y = body_y + body_height
                legs_height = frame_height - legs_y
                legs[legs_y:legs_y + legs_height, x - border:x + w + border] = subtracted[legs_y:legs_y + legs_height,
                                                                               x - border:x + w + border]

        heads = cv2.morphologyEx(heads, cv2.MORPH_CLOSE, kernel, iterations=10)
        boxes = find_contours(heads, MIN_HEAD_AREA)
        seg_data = add_boxes_data(seg_data, boxes, frame_middle, 'head')
        add_boxes(frame, boxes, 'head')

        bodys = cv2.morphologyEx(bodys, cv2.MORPH_CLOSE, kernel, iterations=10)
        boxes = find_contours(bodys, MIN_BODY_AREA)
        seg_data = add_boxes_data(seg_data, boxes, frame_middle, 'body')
        add_boxes(frame, boxes, 'body')

        legs = cv2.morphologyEx(legs, cv2.MORPH_CLOSE, kernel, iterations=10)
        boxes = find_contours(legs, MIN_LEG_AREA)
        seg_data = add_boxes_data(seg_data, boxes, frame_middle, 'legs')
        add_boxes(frame, boxes, 'legs')

        windows.append(['edges', edges])
        windows.append(['subtract', subtracted])
        windows.append(['closed', closed])
        windows.append(['heads', heads])
        windows.append(['bodies', bodys])
        windows.append(['legs', legs])
        windows.append(['boxes', frame])
        show_windows(windows, first)

        if targetFrame > 1:
            cv2.imwrite(ofilename + '_edges.png', edges)
            cv2.imwrite(ofilename + '_subtr.png', subtracted)
            cv2.imwrite(ofilename + '_closed.png', closed)
            cv2.imwrite(ofilename + '_heads.png', heads)
            cv2.imwrite(ofilename + '_bodys.png', bodys)
            cv2.imwrite(ofilename + '_legs.png', legs)
            cv2.imwrite(ofilename + '_boxes.png', frame)
            break

        first = False
        frame_count += 1
        csvwriter.writerow(seg_data)

        done = int((float(frame_count) / frames_total) * 100)
        if last_done < done:
            print "{}%".format(done)
            last_done = done

        k = cv2.waitKey(30) & 0xff
        if k == 27:
            break

    videoCapture.release()
    cv2.destroyAllWindows()

def add_boxes_data(data, boxes, middle, box_type):
    if box_type == 'person':
        start = 1
    elif box_type == 'head':
        start = 1 + 2 * 4
    elif box_type == 'body':
        start = 1 + 4 * 4
    elif box_type == 'legs':
        start = 1 + 6 * 4
    else:
        return data

    for idx, box in enumerate(boxes):
        if box[0] < middle:
            data[start:start + 4] = box
        else:
            data[start + 4:start + 4 + 4] = box

    return data

def add_boxes(frame, boxes, regionTitle = ''):
    frame_width = np.size(frame, 1)
    for idx, box in enumerate(boxes):
        x, y, w, h = box
        cv2.rectangle(frame, (x, y), (x + w, y + h), COLOR_GREEN, 2)
        if x < frame_width / 2:
            sideTitle = 'Left '
        else:
            sideTitle = 'Right '
        showTitle = sideTitle[0] + regionTitle[0].upper()
        cv2.putText(frame, showTitle, (x, y - 3), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255))


def show_windows(windows, first=False):
    x = 1
    y = 1
    max_x = 1500

    for win in windows:
        title, im = win
        cv2.imshow(title, im)
        if first:
            cv2.moveWindow(title, x, y)
            x += np.size(im, 1)
            if x > max_x:
                x = 1
                y += np.size(im, 0) + 30


def usage():
    print "Usage:"
    print "<in-file> <out-file>"
    sys.exit(1)


def segment_all():
    for folder in folders:
        ifname = video_folder + 'C_' + folder + '.avi'
        ofname = data_folder + 'C_' + folder + '.csv'
        print ifname
        bgsubtract(ifname, ofname)


if __name__ == '__main__':
    tfolder = folders[4]
    ifile = video_folder + tfolder + '/C_' + tfolder + '.avi'
    # ofile = data_folder + '/C_' + tfolder + 'blaa.csv'
    # bgsubtract(ifile, ofile)

    for frame in xrange(5490, 5491):
        # ofile = 'extracted/C_' + tfolder + '_' + str(frame)
        ofile = 'extracted/C_' + tfolder + '_' + str(frame)
        extract_frame(ifile, ofile, frame)
        # bgsubtract(ifile, ofile, frame)






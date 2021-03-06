/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the test suite of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtTest 1.0
import QtPositioning 5.2

Item {
    id: testCase

    property variant coordinate1: QtPositioning.coordinate(1, 1)
    property variant coordinate2: QtPositioning.coordinate(2, 2)
    property variant coordinate3: QtPositioning.coordinate(80, 80)

    property variant emptyCircle: QtPositioning.circle()
    property variant circle1: QtPositioning.circle(coordinate1, 200000)

    SignalSpy { id: circleChangedSpy; target: testCase; signalName: "emptyCircleChanged" }

    TestCase {
        name: "Bounding circle"
        function test_circle_defaults_and_setters() {
            circleChangedSpy.clear();
            compare (emptyCircle.radius, -1)
            compare (circle1.radius, 200000)

            emptyCircle.radius = 200
            compare(circleChangedSpy.count, 1);
            emptyCircle.radius = 200;
            compare(circleChangedSpy.count, 1);

            emptyCircle.center = coordinate1;
            compare(circleChangedSpy.count, 2);
            emptyCircle.center = coordinate1
            compare(circleChangedSpy.count, 2);
            emptyCircle.center = coordinate2
            compare(circleChangedSpy.count, 3);

            emptyCircle.center = coordinate1
            emptyCircle.radius = 200000

            compare(emptyCircle.contains(coordinate1), true);
            compare(emptyCircle.contains(coordinate2), true);
            compare(emptyCircle.contains(coordinate3), false);
        }
    }

    // coordinate unit square
    property variant bl: QtPositioning.coordinate(0, 0)
    property variant tl: QtPositioning.coordinate(1, 0)
    property variant tr: QtPositioning.coordinate(1, 1)
    property variant br: QtPositioning.coordinate(0, 1)
    property variant ntr: QtPositioning.coordinate(3, 3)

    property variant inside: QtPositioning.coordinate(0.5, 0.5)
    property variant outside: QtPositioning.coordinate(2, 2)

    property variant box: QtPositioning.rectangle(tl, br)

    // C++ auto test exists for basics of bounding box, testing here
    // only added functionality
    TestCase {
        name: "Bounding box"
        function test_box_defaults_and_setters() {
            compare (box.bottomRight.longitude, br.longitude) // sanity
            compare (box.contains(bl), true)
            compare (box.contains(inside), true)
            compare (box.contains(outside), false)
            box.topRight = ntr
            compare (box.contains(outside), true)
        }
    }
}

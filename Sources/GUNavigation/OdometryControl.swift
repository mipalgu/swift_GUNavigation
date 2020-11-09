/*
 * OdometryControl.swift 
 * GUNavigation 
 *
 * Created by Morgan McColl on 09/11/2020.
 * Copyright © 2020 Morgan McColl. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above
 *    copyright notice, this list of conditions and the following
 *    disclaimer in the documentation and/or other materials
 *    provided with the distribution.
 *
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgement:
 *
 *        This product includes software developed by Morgan McColl.
 *
 * 4. Neither the name of the author nor the names of contributors
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * -----------------------------------------------------------------------
 * This program is free software; you can redistribute it and/or
 * modify it under the above terms or under the terms of the GNU
 * General Public License as published by the Free Software Foundation;
 * either version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see http://www.gnu.org/licenses/
 * or write to the Free Software Foundation, Inc., 51 Franklin Street,
 * Fifth Floor, Boston, MA  02110-1301, USA.
 *
 */

import CGUNavigation

public struct OdometryControl: CTypeWrapper {

    public var forwardControl: Control

    public var forwardController: Controller

    public var leftControl: Control

    public var leftController: Controller

    public var turnControl: Control

    public var turnController: Controller

    public var rawValue: gu_odometry_control {
        gu_odometry_control(
            forward_control: forwardControl.rawValue,
            forward_controller: forwardController.rawValue,
            left_control: leftControl.rawValue,
            left_controller: leftController.rawValue,
            turn_control: turnControl.rawValue,
            turn_controller: turnController.rawValue
        )
    } 

    public init(
        forwardControl: Control = Control(),
        forwardController: Controller = Controller(),
        leftControl: Control = Control(),
        leftController: Controller = Controller(),
        turnControl: Control = Control(),
        turnController: Controller = Controller()
    ) {
        self.forwardControl = forwardControl
        self.forwardController = forwardController
        self.leftControl = leftControl
        self.leftController = leftController
        self.turnControl = turnControl
        self.turnController = turnController
    }

    public init(_ other: gu_odometry_control) {
        self.init(
            forwardControl: Control(other.forward_control),
            forwardController: Controller(other.forward_controller),
            leftControl: Control(other.left_control),
            leftController: Controller(other.left_controller),
            turnControl: Control(other.turn_control),
            turnController: Controller(other.turn_controller)
        )
    }

    public init(
        myPosition: FieldCoordinate,
        target: RelativeCoordinate,
        heading: Angle,
        forwardController: Controller,
        leftController: Controller,
        turnController: Controller
    ) {
        self.init(position_to_odometry_control_with_heading(
            myPosition.rawValue,
            target.rawValue,
            heading.degrees_t.rawValue,
            forwardController.rawValue,
            leftController.rawValue,
            turnController.rawValue
        ))
    }

    public init(
        target: RelativeCoordinate,
        forwardController: Controller,
        leftController: Controller,
        turnController: Controller
    ) {
        self.init(position_to_odometry_control(
            target.rawValue,
            forwardController.rawValue,
            leftController.rawValue,
            turnController.rawValue
        ))
    }

}





















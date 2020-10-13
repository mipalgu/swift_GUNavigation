/*
 * OdometryStatus.swift 
 * GUNavigation 
 *
 * Created by Morgan McColl on 13/10/2020.
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
import GUUnits
import GUCoordinates

public struct OdometryStatus {
    
    private enum Coordinate: Hashable, Codable {
        
        enum CodingKeys: String, CodingKey {
            case type
            case value
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let type = try values.decode(Bool.self, forKey: .type)
            switch type {
            case true:
                let value = try values.decode(CartesianCoordinate.self, forKey: .value)
                self = .cartesian(value)
            case false:
                let value = try values.decode(RelativeCoordinate.self, forKey: .value)
                self = .relative(value)
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .cartesian(let coordinate):
                try container.encode(true, forKey: .type)
                try container.encode(coordinate, forKey: .value)
            case .relative(let coordinate):
                try container.encode(false, forKey: .type)
                try container.encode(coordinate, forKey: .value)
            }
        }
        
        case cartesian(CartesianCoordinate)
        case relative(RelativeCoordinate)
    }
    
    public var forward: Distance

    public var left: Distance

    public var turn: Angle

    private var coordinate: Coordinate
    
    public var relativeCoordinate: RelativeCoordinate? {
        switch coordinate {
        case .relative(let coordinate):
            return coordinate
        default:
            return nil
        }
    }

    public var cartesianCoordinate: CartesianCoordinate? {
        switch coordinate {
        case .cartesian(let coordinate):
            return coordinate
        default:
            return nil
        } 
    }


    public init(cartesian other: gu_odometry_status) {
        self.init(
            forward: Distance(Millimetres_t(rawValue: other.forward)),
            left: Distance(Millimetres_t(rawValue: other.left)),
            turn: Angle(Radians_d(rawValue: other.turn)),
            coordinate: CartesianCoordinate(other.cartesian_coordinate)
        )
    }

    public init(relative other: gu_odometry_status) {
        self.init(
            forward: Distance(Millimetres_t(rawValue: other.forward)),
            left: Distance(Millimetres_t(rawValue: other.left)),
            turn: Angle(Radians_d(rawValue: other.turn)),
            coordinate: RelativeCoordinate(other.relative_coordinate)
        )
    }

    public init(
        forward: Distance = .zero,
        left: Distance = .zero,
        turn: Angle = .zero,
        coordinate: CartesianCoordinate
    ) {
        self.forward = forward
        self.left = left
        self.turn = turn
        self.coordinate = .cartesian(coordinate)
    }

    public init(
        forward: Distance = .zero,
        left: Distance = .zero,
        turn: Angle = .zero,
        coordinate: RelativeCoordinate
    ) {
        self.forward = forward
        self.left = left
        self.turn = turn
        self.coordinate = .relative(coordinate)
    }

}


extension OdometryStatus: Hashable, Codable {}


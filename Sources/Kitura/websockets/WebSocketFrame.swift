/*
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

public class WebSocketFrame {

	public enum OpCode: UInt8 {
        case `continue` = 0x00
        case text = 0x01
        case binary = 0x02
        case close = 0x08
        case ping = 0x09
        case pong = 0x0A
    }

    public init(_ fin: Bool, _ opcode: OpCode, _ paylod: [UInt8]) {
    	self.fin = fin
    	self.opcode = opcode
    	self.payload = paylod
    }

	public let opcode: OpCode
	public let payload: [UInt8]
	public let fin: Bool
}
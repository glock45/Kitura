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

public enum WebSocketParserError: Swift.Error  {
	case unknownOpCode(String)
	case unMaskedFrame
	case notImplemented(String)
}

public class WebSocketParser {

	private var buffer = Data(capacity: 1024)

 	public func parse(_ data: Data) throws -> WebSocketFrame? {

 		buffer.append(data)

 		guard buffer.count > 1 else { 
 			return nil
 		}
        
        let fin = buffer[0] & 0x80 != 0
        let opc = buffer[0] & 0x0F
        let masked = buffer[1] & 0x80 != 0
        let length = Int(buffer[1] & 0x7F)

        guard length < 0x7E else {
        	throw WebSocketParserError.notImplemented("Long messages not supported.")
        }
        
        guard let opcode = WebSocketFrame.OpCode(rawValue: opc) else {
            // "If an unknown opcode is received, the receiving endpoint MUST _Fail the WebSocket Connection_." 
            // http://tools.ietf.org/html/rfc6455#section-5.2 ( Page 29 )
            throw WebSocketParserError.unknownOpCode("\(opc)")
        }

        guard masked else {
            // "...a client MUST mask all frames that it sends to the serve.." 
            // http://tools.ietf.org/html/rfc6455#section-5.1
            throw WebSocketParserError.unMaskedFrame
        }
        
        guard (length + 6 /* mask + preambule */ ) >= buffer.count else {
            return nil
        }

        var payload = [UInt8]()

        for i in 0..<length {
        	payload.append(buffer[6+i] ^ buffer[2 + (i % 4)])
		}

		buffer.removeSubrange(0..<length+6)

 		return WebSocketFrame(fin, opcode, payload)
 	}
}
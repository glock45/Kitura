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

public class WebSocketIncomingFrameProcessor {
	
	private let delegate: WebSocketDelegate

	public init(_ delegate: WebSocketDelegate) {
		self.delegate = delegate
	}

	public func process(_ frame: WebSocketFrame) {
		switch frame.opcode {
			case .text:
				if let text = String(data: Data(frame.payload), encoding: String.Encoding.utf8) {
					delegate.onText(text)
				}
			case .binary:
				delegate.onBinary(Data(frame.payload))
			default:
				break
		}
	}
}
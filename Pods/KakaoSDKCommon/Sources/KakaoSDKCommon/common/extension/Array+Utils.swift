//  Copyright 2019 Kakao Corp.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

#if swift(>=5.8)
@_documentation(visibility: private)
#endif
extension Array where Element == String {
    public func toJsonString() -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options:[]) {
            return String(data:data, encoding: .utf8)
        }
        else {
            return nil
        }
    }
}

#if swift(>=5.8)
@_documentation(visibility: private)
#endif
extension Array where Element == Int64 {
    public func toJsonString() -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options:[]) {
            return String(data:data, encoding: .utf8)
        }
        else {
            return nil
        }
    }
}

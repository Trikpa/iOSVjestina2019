//
//  ServerResponseEnum.swift
//  iOSVjestina2019
//
//  Created by Five on 01/06/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import Foundation

enum ServerResponse: Int {
    case OK = 200
    case BAD_REQUEST = 400
    case UNAUTHORIZED = 401
    case FORBIDDEN = 403
    case NOT_FOUND = 404
}

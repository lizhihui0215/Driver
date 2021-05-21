//
// Created by lizhihui on 2021/4/26.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import Foundation
import SwiftyBeaver

let log = LoggerService.shared.log

class LoggerService {
    public static let shared = LoggerService()
    let console = ConsoleDestination()
    let file = FileDestination()
    let log = SwiftyBeaver.self

    init() {
        console.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M $X"
        log.addDestination(console)
        log.addDestination(file)
    }
}

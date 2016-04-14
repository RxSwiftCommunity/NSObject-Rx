//
//  Mock.swift
//  Demo
//
//  Created by Segii Shulga on 4/13/16.
//  Copyright © 2016 Ash Furrow. All rights reserved.
//

import Foundation

class Mock: NSObject {
    dynamic var number: NSNumber = 1
    
    dynamic func funcWithOutParams() {
        print("funcWithOutParams")
    }
    
    dynamic func funcWhichReturnsBool() -> Bool {
        return false
    }
    
    dynamic func funcWithParamsReturnsVoid(param: AnyObject) {
    }
    
    dynamic func funcWithParamsReturnsParam(param: AnyObject) -> AnyObject {
        return param
    }
    
    dynamic func funcWithClosure(closure: () -> ()) {
        closure()
    }
    
    deinit {
        print("deinit self")
    }
    
}

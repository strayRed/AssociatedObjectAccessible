//
//  AssociatedObjectAccessible.swift
//
//  Created by strayRed on 2021/10/27.
//

import Foundation

extension NSObject: AssociatedObjectAccessible { }

public protocol AssociatedObjectAccessible {
    
    var associatedObjectParent: AnyObject { get }
    
    func setRetainedAssociatedObject(_ object: Any?, forKey key: UnsafeRawPointer)
    
    func setAssignAssociatedObject(_ object: Any?, forKey key: UnsafeRawPointer)
    
    func getAssociatedObject<T>(forKey key: UnsafeRawPointer, default: @autoclosure () -> T) -> T
    
    func getLazyAssociatedObject<T>(forKey key: UnsafeRawPointer, default: () -> T) -> T
    
    func getAssociatedObject<T>(forKey key: UnsafeRawPointer) -> T?
}


extension AssociatedObjectAccessible {
    
    public func setRetainedAssociatedObject(_ object: Any?, forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(associatedObjectParent, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public  func setAssignAssociatedObject(_ object: Any?, forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(associatedObjectParent, key, object, .OBJC_ASSOCIATION_ASSIGN)
    }
    
    public func getAssociatedObject<T>(forKey key: UnsafeRawPointer, default: @autoclosure () -> T) -> T {
        if let object: T = getAssociatedObject(forKey: key) {
            return object
        }
        let object = `default`()
        setRetainedAssociatedObject(object, forKey: key)
        return object
    }
    
    public func getLazyAssociatedObject<T>(forKey key: UnsafeRawPointer, default: () -> T) -> T {
        if let object: T = getAssociatedObject(forKey: key) {
            return object
        }
        let object = `default`()
        setRetainedAssociatedObject(object, forKey: key)
        return object
    }
    
    public func getAssociatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(associatedObjectParent, key) as? T
    }
}

extension AssociatedObjectAccessible where Self: AnyObject {
    public var associatedObjectParent: AnyObject { self }
}
 

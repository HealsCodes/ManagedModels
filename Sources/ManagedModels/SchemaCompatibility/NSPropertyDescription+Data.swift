//
//  Created by Helge Heß.
//  Copyright © 2023 ZeeZide GmbH.
//

extension NSPropertyDescription {
  private struct AssociatedKeys {
    nonisolated(unsafe) static var propertyIsUniqueAssociatedKey: Void? = nil
  }
  
  public internal(set) var isUnique: Bool {
    // Note: isUnique is only used during schema construction!
    set {
      if newValue {
        objc_setAssociatedObject(self, &AssociatedKeys.propertyIsUniqueAssociatedKey,
                                 type(of: self), .OBJC_ASSOCIATION_ASSIGN)
      }
      else {
        objc_setAssociatedObject(self, &AssociatedKeys.propertyIsUniqueAssociatedKey, nil, .OBJC_ASSOCIATION_RETAIN)
      }
#if false // do we need this? The entity might not yet be setup?
      guard !entity.isPropertyUnique(self) else { return }
      entity.uniquenessConstraints.append( [ self ])
#endif
    }
    get {
      objc_getAssociatedObject(self, &AssociatedKeys.propertyIsUniqueAssociatedKey) != nil
      ? true
      : entity.isPropertyUnique(self)
    }
  }
}



import Foundation
import Cocoa

extension NSBezierPath
{
    func convertToCGPath() -> CGPathRef!
    {
        let tElementCount = self.elementCount
        if tElementCount <= 0
        {
            return nil
        }
        
        let tPath = CGPathCreateMutable()
        let tPointsMArray = NSPointArray.alloc( 3 )
        //let tDidClosePath: Bool = true
        
        for tIndex in 0 ..< tElementCount
        {
            switch elementAtIndex( tIndex, associatedPoints: tPointsMArray )
            {
            case NSBezierPathElement.MoveToBezierPathElement:
                CGPathMoveToPoint( tPath, nil, tPointsMArray[0].x, tPointsMArray[0].y )
                
            case NSBezierPathElement.LineToBezierPathElement:
                CGPathAddLineToPoint( tPath, nil, tPointsMArray[0].x, tPointsMArray[0].y )
               // tDidClosePath = false
                
            case NSBezierPathElement.CurveToBezierPathElement:
                CGPathAddCurveToPoint( tPath, nil, tPointsMArray[0].x, tPointsMArray[0].y, tPointsMArray[1].x, tPointsMArray[1].y,tPointsMArray[2].x, tPointsMArray[2].y )
              //  tDidClosePath = false
                
            case NSBezierPathElement.ClosePathBezierPathElement:
                CGPathCloseSubpath( tPath )
             //   tDidClosePath = true
            }
            
//            if !tDidClosePath
//            {
//                //  Ensure path is closed
//                CGPathCloseSubpath( tPath )
//            }
        }
        
        return CGPathCreateCopy( tPath )
    }
}
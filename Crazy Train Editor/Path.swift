

import Foundation
enum Type {
    case road
    case rail
    case walk
    case cross
    case crazyPedestrian
    case garbage
}


public class Path {
    var path: [[CGPoint]]
    var type: Type
    var tileWidth: CGFloat
    var tileHeigth: CGFloat
    
    
    init(type: Type, tileWidth: CGFloat, tileHeight: CGFloat, pointsArray: [[CGPoint]]){
        path = pointsArray
        self.type = type;
        self.tileWidth = tileWidth
        self.tileHeigth = tileHeight
        let myArray: [CGPoint] = []
        path.append(myArray)
    }
    
    
    func print() ->String{
        return String(buildData())
    }
    /*func print() -> String{
        var str = ""
        if type == Type.road{
            str += "road"
        }
        if type == Type.rail{
            str += "rail"
        }
        if type == Type.walk{
            str += "walk"
        }
        if type == Type.cross{
            str += "cross"
        }
        if type == Type.crazyPedestrian{
            str += "crazyPedestrian"
        }
        if type == Type.garbage{
            str += "garbage"
        }
        str += ":"
        if type == Type.garbage{
            str += String(dataPoint(centerPoint(path[0][0])).x) + "," + String(dataPoint(centerPoint(path[0][0])).y)
        }else{
        for var i = 0; i < path.count; i = i + 1{
            for var point = 0; point < path[i].count; point = point + 1 {
                str += String(dataPoint(path[i][point]).x) + "," + String(dataPoint(path[i][point]).y)
                if point != path[i].count - 1{
                    str += "@"
                }
            }
            if i != path.count - 1{
                str += "#"
            }
            
        }
    }
        return str
    }*/
    
    func buildCGPath() -> CGPathRef{
        let myPath = CGPathCreateMutable()
        
        for a in path{
            if a.count == 2 {
                // Draw a straight line
                //if path[0] == a {
                    CGPathMoveToPoint ( myPath , nil, centerPoint(a[0]).x, centerPoint(a[0]).y )
                //}
                CGPathAddLineToPoint( myPath, nil, centerPoint(a[1]).x, centerPoint(a[1]).y )
                
            }else if a.count == 3 {
                // Draw curve with 3 points
                //if path[0] == a {
                    
                    CGPathMoveToPoint( myPath , nil, centerPoint(a[0]).x, centerPoint(a[0]).y )
                //}
                CGPathAddCurveToPoint( myPath, nil, centerPoint(a[2]).x, centerPoint(a[2]).y, centerPoint(a[2]).x, centerPoint(a[2]).y,centerPoint(a[1]).x, centerPoint(a[1]).y )
                
            }else if a.count == 4 {
                //if path[0] == a {
                    CGPathMoveToPoint( myPath , nil, centerPoint(a[0]).x, centerPoint(a[0]).y )
                //}
                CGPathAddCurveToPoint( myPath, nil, centerPoint(a[2]).x, centerPoint(a[2]).y, centerPoint(a[3]).x, centerPoint(a[3]).y,centerPoint(a[1]).x, centerPoint(a[1]).y )
            }
        }
        return myPath
    }
    // make point at the botton left of the square that the mouse is on
    func newPoint(point: CGPoint) -> CGPoint{
        return CGPointMake(floor(point.x / tileWidth) * tileWidth, floor(point.y / tileHeigth) * tileHeigth)
    }
    //make point at the top right of the square mouse is - center of the 2 by 2 tile
    func centerPoint(point: CGPoint) -> CGPoint{
        return CGPointMake((floor(point.x / tileWidth) * tileWidth) + tileWidth, (floor(point.y / tileHeigth) * tileHeigth) + tileHeigth)
    }
    
    func dataPoint(point: CGPoint) -> CGPoint{
        return CGPointMake(((point.x)/CGFloat(tileWidth)) - CGFloat(MARGIN_LEFT), ((point.y)/CGFloat(tileHeigth)) - CGFloat(MARGIN_TOP))
    }
    
    func draw(context: CGContextRef){
        if type != Type.garbage{
            let myPath = buildCGPath()
            if self.type == Type.road{
                CGContextSetLineWidth(context, 53)
                CGContextAddPath(context, myPath)
                CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(96/255, 96/255, 96/255, 1))//gray
                CGContextDrawPath(context, CGPathDrawingMode.Stroke)
                
            }else if self.type == Type.rail{
                CGContextSetLineWidth(context, 20)
                let myDashedPath = CGPathCreateCopyByDashingPath(myPath, nil, 0, [5.0,5.0], 2)
                CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(102/255, 51/255, 0, 1))//brown
                CGContextAddPath(context, myDashedPath)
                CGContextDrawPath(context, CGPathDrawingMode.Stroke)
                CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(180/255, 180/255, 180/255, 1))//black
                let outPath = CGPathCreateCopyByStrokingPath(myPath, nil, 10, CGLineCap.Round , CGLineJoin.Round, 0)
                CGContextSetLineWidth(context, 2)
                CGContextAddPath(context, outPath)
                CGContextDrawPath(context, CGPathDrawingMode.Stroke)
            }else if self.type == Type.cross{
                CGContextSetLineWidth(context, 30)
                let myDashedPath = CGPathCreateCopyByDashingPath(myPath, nil, 0, [7.0,7.0], 2)
                CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(1, 1, 1, 1))
                CGContextAddPath(context, myDashedPath)
                CGContextDrawPath(context, CGPathDrawingMode.Stroke)
            }else if self.type == Type.walk{
                CGContextSetLineWidth(context, 15)
                CGContextAddPath(context, myPath)
                CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(167/255, 125/255, 73/255, 1))
                CGContextDrawPath(context, CGPathDrawingMode.Stroke)
            }else{
                CGContextSetLineWidth(context, 2)
                CGContextAddPath(context, myPath)
                CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(0, 0, 0, 1))
                CGContextDrawPath(context, CGPathDrawingMode.Stroke)
            }
        }
        
            for a in path{
                for var i = 0; i < a.count; i = i + 1 {
                    if self.type == Type.garbage{
                        let tileDraw = CGPathCreateMutable()
                        CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0, 1, 0, 1))

                        CGPathMoveToPoint( tileDraw , nil, a[i].x, a[i].y )
                        CGPathAddLineToPoint( tileDraw, nil, a[i].x + tileWidth * CGFloat(2), a[i].y)
                        CGPathAddLineToPoint( tileDraw, nil, a[i].x + tileWidth * CGFloat(2), a[i].y + tileHeigth * CGFloat(2))
                        CGPathAddLineToPoint( tileDraw, nil, a[i].x, a[i].y + tileHeigth * CGFloat(2) )
                        CGPathCloseSubpath( tileDraw )
                        CGContextAddPath(context, tileDraw)
                        CGContextDrawPath(context, CGPathDrawingMode.Fill)

                    }else{
                    let tileDraw = CGPathCreateMutable()
                    CGPathMoveToPoint( tileDraw , nil, a[i].x, a[i].y )
                    CGPathAddLineToPoint( tileDraw, nil, a[i].x + tileWidth * CGFloat(2), a[i].y)
                    CGPathAddLineToPoint( tileDraw, nil, a[i].x + tileWidth * CGFloat(2), a[i].y + tileHeigth * CGFloat(2))
                    CGPathAddLineToPoint( tileDraw, nil, a[i].x, a[i].y + tileHeigth * CGFloat(2) )
                    CGPathCloseSubpath( tileDraw )
                    CGContextAddPath(context, tileDraw)
                    CGContextDrawPath(context, CGPathDrawingMode.Fill)
                    }
                }
            }
        
    }
    
    func buildData() -> Dictionary<String, AnyObject>{
        var dataDictionary = [String: AnyObject]()
        switch type{
        case Type.road: dataDictionary["Type"] = "road"
        case Type.rail: dataDictionary["Type"] = "rail"
        case Type.walk: dataDictionary["Type"] = "walk"
        case Type.cross: dataDictionary["Type"] = "cross"
        case Type.crazyPedestrian: dataDictionary["Type"] = "crazyPedestrian"
        case Type.garbage: dataDictionary["Type"] = "garbage"
        }
        var pointsArray: [[[CGFloat]]] = []
        
        for curve in path{
            var curvesArray: [[CGFloat]] = []
            for point in curve{
                var pointArray: [CGFloat] = []
                pointArray.append(dataPoint(point).x)
                pointArray.append(dataPoint(point).y)
                curvesArray.append(pointArray)
            }
            pointsArray.append(curvesArray)
        }
        dataDictionary["points"] = pointsArray
 
        return dataDictionary
    }
}
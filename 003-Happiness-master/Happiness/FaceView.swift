//
//  FaceView.swift
//  Happiness
//
//  Created by 米明 on 15/6/23.
//  Copyright (c) 2015年 米明. All rights reserved.
//

import UIKit

@IBDesignable 
class FaceView: UIView
{
    @IBInspectable
    //线的宽度
    var lineWidth : CGFloat = 3 { didSet {setNeedsDisplay() } }
    
    @IBInspectable
    //线的颜色
    var color : UIColor = UIColor.blueColor() { didSet {setNeedsDisplay() } }
    
    @IBInspectable
    //表情缩放系数
    var scale : CGFloat = 0.90 {didSet { setNeedsDisplay() } }
    
    @IBInspectable
    //微笑程度（幸福指数）
    var smiliness : Double = 0.75 {didSet { setNeedsDisplay() } }
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio:CGFloat = 10//眼睛弯曲半径比例
        static let FaceRadiusToEyeOffsetRatio:CGFloat = 3//眼睛偏移比例
        static let FaceRadiusToEyeSeparationRatio:CGFloat = 1.5//眼睛间隙比例
        static let FaceRadiusToMouthWidthRatio:CGFloat = 1//嘴宽度比例
        static let FaceRadiusToMouthHeightRatio:CGFloat = 3//嘴高度比例
        static let FaceRadiusToMouthOffsetRatio:CGFloat = 3//嘴便宜比例
    }
    
    private enum Eye { case  Left, Right }
    
    //眼睛
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath
    {
        //计算眼睛的半径
        let eyeRadius = faceRadius/Scaling.FaceRadiusToEyeRadiusRatio
        //计算眼睛垂直的偏移量
        let eyeVerticalOffset = faceRadius/Scaling.FaceRadiusToEyeOffsetRatio
        //计算眼睛水平的距离
        let eyeHorizontalSeparation = faceRadius/Scaling.FaceRadiusToEyeSeparationRatio
        //眼睛中心
        var eyeCenter = faceCenter
        //y值是一致的
        eyeCenter.y -= eyeVerticalOffset
        //根据左右来计算 眼的圆心x坐标
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        //调用上面用过的UIBezierPath画圆的类方法来画圆
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        //线的宽
        path.lineWidth = lineWidth
        //最后返回路径
        return path
    }
    
    //微笑
    private func bezierPathForSmile(fractionOfMaxSmile : Double) -> UIBezierPath
    {
        //嘴宽
        let mouthWidth = faceRadius/Scaling.FaceRadiusToMouthWidthRatio
        //嘴高
        let mouthHeight = faceRadius/Scaling.FaceRadiusToMouthHeightRatio
        //嘴垂直偏移
        let mouthVerticalOffset = faceRadius/Scaling.FaceRadiusToMouthOffsetRatio
        //微笑高度
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        //开始点
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        //结束点
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        //第一个控制点
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        //第二个控制点
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        //路径移至起点
        path.moveToPoint(start)
        //增加路径的终点、控制点
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    var faceCenter:CGPoint {
        get{
            return convertPoint(center, fromView: superview)
        }
    }
    
    var faceRadius:CGFloat {
        get{
            return scale * min(bounds.size.width,bounds.size.height) / 2
        }
    }
    
    override func drawRect(rect: CGRect){
        //圆圆的脸
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        //一双大眼
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        //嘴
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
        
    }


}

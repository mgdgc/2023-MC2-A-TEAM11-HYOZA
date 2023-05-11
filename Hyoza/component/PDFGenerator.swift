//
//  PDFGenerator.swift
//  CoreDataTest
//
//  Created by 최명근 on 2023/05/09.
//

import PDFKit

class PDFGenerator {
    
    func generatePDF(title: String, texts: [PDFText]) -> Data {
        let metaData = [
            kCGPDFContextCreator: "PDFGenerator",
            kCGPDFContextAuthor: "MGChoi",
            kCGPDFContextTitle: "I Love Christmas"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = metaData as [String: Any]
        
        let pageSize = CGRect(x: 10, y: 10, width: 595.2, height: 841.8)
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: pageSize, format: format)
        
        let data = pdfRenderer.pdfData { context in
            context.beginPage()
            
            context.addTitle(title, pdfSize: pageSize)
            
            var cursor: CGFloat = 40
            
            for text in texts {
                cursor += text.spacing.top
                cursor = context.addText(text, pdfSize: pageSize, cursor: cursor, indent: text.indent)
                cursor += text.spacing.bottom
            }
            
        }
        
        return data
    }
    
}

extension UIGraphicsPDFRendererContext {
    
    func addTitle(_ text: String, pdfSize: CGRect) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        
        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle : paragraphStyle,
            .font : UIFont.systemFont(ofSize: 48, weight: .bold)
        ]
        
        let pdfText = NSAttributedString(string: text, attributes: attributes)
        let pdfTextWidth = pdfSize.width
        let constraintSize = CGSize(width: pdfTextWidth, height: .greatestFiniteMagnitude)
        let pdfTextHeight = pdfText.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin], context: nil).height
        
        let pdfTextSize = CGRect(x: 20, y: pdfSize.height / 2 - pdfTextHeight, width: pdfSize.width - 40, height: pdfTextHeight)
        pdfText.draw(in: pdfTextSize)
        
        beginPage()
    }
    
    func addText(_ text: PDFText, pdfSize: CGRect, cursor: CGFloat, indent: CGFloat) -> CGFloat {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = text.alignment
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        
        var attributes: [NSAttributedString.Key : Any] = text.attributes
        attributes[.paragraphStyle] = paragraphStyle
        
        let pdfText = NSAttributedString(string: text.string, attributes: attributes)
        let pdfTextWidth = pdfSize.width - (20 * indent)
        let constraintSize = CGSize(width: pdfTextWidth - (20 * indent), height: .greatestFiniteMagnitude)
        let pdfTextHeight = pdfText.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin], context: nil).height
        
        let pdfTextSize = CGRect(x: 20 + 20 * indent, y: cursor, width: pdfSize.width - 20 - 20 * indent, height: pdfTextHeight)
        pdfText.draw(in: pdfTextSize)
        
        if cursor > pdfSize.height - 100 {
            self.beginPage()
            return 40
        } else {
            return cursor + pdfTextHeight
        }
    }
    
}

struct PDFText {
    var string: String
    var attributes: [NSAttributedString.Key : Any]
    var alignment: NSTextAlignment = .right
    var indent: CGFloat = 1.0
    var spacing: PDFSpacing = PDFSpacing(top: 60, bottom: 40)
}

struct PDFSpacing {
    var top: CGFloat
    var bottom: CGFloat
    
    static let title: PDFSpacing = PDFSpacing(top: 20, bottom: 20)
    static let question: PDFSpacing = PDFSpacing(top: 20, bottom: 10)
    static let answer: PDFSpacing = PDFSpacing(top: 0, bottom: 10)
    static let comment: PDFSpacing = PDFSpacing(top: 0, bottom: 10)
    static let date: PDFSpacing = PDFSpacing(top: 0, bottom: 4)
}

class PDFTextStyle {
    
    static var title: [NSAttributedString.Key : Any] {
        let font = UIFont.systemFont(ofSize: 48, weight: .bold)
        return [.font: font]
    }
    
    static var question: [NSAttributedString.Key : Any] {
        let font = UIFont.systemFont(ofSize: 36, weight: .bold)
        return [.font: font]
    }
    
    static var answer: [NSAttributedString.Key : Any] {
        let font = UIFont.systemFont(ofSize: 24, weight: .regular)
        return [.font: font]
    }
    
    static var comment: [NSAttributedString.Key : Any] {
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return [.font: font]
    }
    
    static var date: [NSAttributedString.Key : Any] {
        let font = UIFont.systemFont(ofSize: 14, weight: .thin)
        return [.font: font]
    }
}

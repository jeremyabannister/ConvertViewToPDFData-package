//
//  convert_view_to_pdf_data.swift
//  ConvertViewToPDFData-package
//
//  Created by Jeremy Bannister on 9/28/24.
//

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension View {
    
    /// Uses the view to produce a PDF with the given dimensions.
    public func convertToPDFData(
        widthInInches: Double,
        heightInInches: Double
    ) throws -> Data {
        
        let pointsPerInch = 72.0
        let widthInPoints = widthInInches * pointsPerInch
        let heightInPoints = heightInInches * pointsPerInch
        
        return try self
            .frame(width: widthInPoints, height: heightInPoints)
            .convertToPDFData()
    }
}


@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension View {
    public func convertToPDFData() throws -> Data {
        
        let renderer = ImageRenderer(content: self)
        let temporaryOutputFile = FileManager.default.temporaryDirectory.appending(path: "temporaryPDDFOutput.pdf")
        
        renderer.render { size, renderer in
            
            var mediaBox =
                CGRect(
                    origin: .zero,
                    size: size
                )
            
            guard let consumer = CGDataConsumer(url: temporaryOutputFile as CFURL) else { return }
            
            guard let pdfContext =
                CGContext(
                    consumer: consumer,
                    mediaBox: &mediaBox,
                    nil
                )
            else { return }
            
            pdfContext.beginPDFPage(nil)
            renderer(pdfContext)
            pdfContext.endPDFPage()
            pdfContext.closePDF()
        }
        
        let pdfData = try Data(contentsOf: temporaryOutputFile)
        try? FileManager.default.removeItem(at: temporaryOutputFile)
        return pdfData
    }
}

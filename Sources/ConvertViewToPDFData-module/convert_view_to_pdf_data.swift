//
//  convert_view_to_pdf_data.swift
//  ConvertViewToPDFData-package
//
//  Created by Jeremy Bannister on 9/28/24.
//

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension View {
    
    /// Uses the view to produce a PDF of size 8.5 inches x 11 inches, which is the standard page size in the US.
    public func convertToPDFData_8_point_5_by_11_inches() throws -> Data {
        try self
            .frame(width: 612, height: 792)
            .convertToPDFData()
    }
    
    /// Uses the view to produce a PDF of size 8.27 inches x 11.69 inches, which is the standard page size in the EU.
    public func convertToPDFData_8_point_27_by_11_point_69_inches() throws -> Data {
        try self
            .frame(width: 595.44, height: 841.68)
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

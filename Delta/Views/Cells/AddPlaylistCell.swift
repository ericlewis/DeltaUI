import SwiftUI
import SFSafeSymbols

struct ColorfulSquare: View {
    var symbol: SFSymbol
    
    
    struct circle: View {
        var color: Color
        
        init(_ color: Color) {
            self.color = color
        }
        
        var body: some View {
            Circle()
                .foregroundColor(color)
                .aspectRatio(1, contentMode: .fit)
        }
    }
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    circle(.purple)
                    circle(.green)
                }
                HStack(spacing: 0) {
                    circle(.orange)
                    circle(.red)
                }
            }
            .blur(radius: 25)
            .saturation(1.5)
            Image(systemSymbol: symbol)
                .resizable()
                .imageScale(.large)
                .foregroundColor(.secondary)
                .padding()
                .blendMode(.hardLight)
        }
        .mask(RoundedRectangle(cornerRadius: 3))
    }
}

struct AddCell: View {
    var body: some View {
        HStack {
            ColorfulSquare(symbol: .plus)
                .frame(width: 80, height: 80)
            Text("New Playlist...")
                .foregroundColor(.accentColor)
        }
    }
}

struct AddCell_Previews: PreviewProvider {
    static var previews: some View {
        AddCell()
    }
}

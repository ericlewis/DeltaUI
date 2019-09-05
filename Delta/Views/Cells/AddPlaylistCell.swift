import SwiftUI

struct AddCell: View {
  
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
  
    var Placeholder: some View {
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
            Image(systemSymbol: .plus)
                .resizable()
                .imageScale(.large)
                .foregroundColor(.secondary)
                .padding()
                .blendMode(.hardLight)
        }
        .mask(RoundedRectangle(cornerRadius: 3))
        .frame(width: 80, height: 80)
    }
    
    var body: some View {
        HStack {
            Placeholder
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

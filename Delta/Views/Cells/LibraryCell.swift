import SwiftUI

struct LibraryCell: View {
    var title: String
    var showChevron: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(title)
                .foregroundColor(.accentColor)
                Spacer()
                if showChevron {
                    Image(systemSymbol: .chevronRight)
                    .imageScale(.small)
                    .foregroundColor(.secondary)
                }
            }
            .padding(.top, showChevron ? 2 : 0)
            if showChevron {
                Divider()
            }
        }
    }
}

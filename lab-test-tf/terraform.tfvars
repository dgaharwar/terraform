# Same ERB pattern as customer repo — values come from Morpheus customOptions, not -var flags.
clouds = "<%=customOptions['cloudSelector']%>"
groups = "<%=customOptions['groupSelector']%>"

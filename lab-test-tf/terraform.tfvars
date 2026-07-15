# Same ERB pattern as customer repo — values come from Morpheus customOptions, not -var flags.
dg_cloud = "<%=customOptions['cloudSelector']%>"
dg_group = "<%=customOptions['groupSelector']%>"

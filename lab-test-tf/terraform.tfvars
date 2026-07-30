# Same ERB pattern as customer repo — values come from Morpheus customOptions, not -var flags.
cloudSelector = "<%=customOptions['dg_cloud']%>"
groupSelector = "<%=customOptions['dg_group']%>"

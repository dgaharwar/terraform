# Same ERB pattern as customer repo — values come from Morpheus customOptions, not -var flags.
cloud = "<%=customOptions['cloudSelector']%>"
group = "<%=customOptions['groups']%>"

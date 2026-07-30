# Same ERB pattern as customer repo — values come from Morpheus customOptions, not -var flags.
cloudk = "<%=customOptions['cloudSelector']%>"
groupk = "<%=customOptions['groupSelector']%>"

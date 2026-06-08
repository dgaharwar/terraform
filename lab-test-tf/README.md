# Lab test — Case 5403063369 (simplified Terraform)

Stripped-down version of [Kyndryl's Terraform](https://github.com/dgaharwar/terraform/tree/master/tf-5403063369-kyndryl) for Morpheus lab testing **without** Nutanix, Infoblox, HTTP providers, or any Terraform provider block.

## What is preserved (failure pattern)

| Customer code | This repro |
|---------------|------------|
| `split("-", var.cloud)[1]` in `locals` | Same in `main.tf` |
| `yamldecode(file(local.cloud_file))` | Same — expects `<Name>.yaml` beside TF files |
| `cloud = "<%=customOptions['cloud']%>"` in `terraform.tfvars` | Same ERB binding |
| Cloud option value `zoneId-cloudName` | Use e.g. `3-LabCloud` → loads `LabCloud.yaml` |

**Expected error when `cloud` is missing** (blueprint catalog without `config.customOptions`):

```
Error: Invalid function argument
  on main.tf line N, in locals:
  N:   cloud_file = "${split("-", var.cloud)[1]}.yaml"
    ├────────────────
    │ var.cloud is "null"
```

Or Terraform may report the variable as unset before plan runs.

## Quick local sanity check (optional)

```bash
cd scratch/5403063369/lab-test-tf

# Should fail — mimics missing customOptions.cloud
terraform plan -var='cloud='

# Should succeed
terraform plan -var='cloud=3-LabCloud' -var='hostname=test01'
```

Morpheus does not use `-var`; it renders `terraform.tfvars` via ERB. Local commands above only verify the HCL logic.

---

## Morpheus lab setup

### 1. Spec Template

- **Source:** Git (this folder) or upload files into a Morpheus spec template
- **Path:** root of this directory
- Ensure `LabCloud.yaml` is included in the template

### 2. Instance Type + Layout

- Provision type: **Terraform**
- Attach the spec template to the layout
- Add **Option Types** on the instance type (field context `config.customOptions`):

| Code | Type | Notes |
|------|------|-------|
| `cloud` | cloud (or text for quick test) | Value must be `zoneId-Label` e.g. `3-LabCloud` |
| `hostname` | text | Any hostname |

For a quick test without a real cloud option type, use a **text** option `cloud` and default `3-LabCloud`.

### 3. Instance catalog item (should work)

Use config JSON like:

```json
{
  "group": { "id": "<%=customOptions.groups%>" },
  "cloud": { "id": "<%=customOptions.cloud.split(/[-]/)[0]%>" },
  "type": "<your-instance-type-code>",
  "name": "<%=customOptions.hostname%>",
  "config": {
    "customOptions": {
      "cloud": "<%=customOptions.cloud%>",
      "hostname": "<%=customOptions.hostname%>"
    }
  },
  "layout": { "id": <layout-id> },
  "plan": { "id": <plan-id> }
}
```

Attach a catalog form with `cloud` and `hostname` fields.

### 4. App Blueprint catalog (reproduces failure)

1. Create **Morpheus-type** App Blueprint using the instance type above.
2. Create **Blueprint catalog item** → **Configure** via app wizard.
3. **Failure case:** complete wizard without `config.customOptions` on the tier instance (or empty `cloud`).
4. **Success case:** ensure generated `appSpec` includes:

```yaml
tiers:
  Default:
    instances:
      - config:
          customOptions:
            cloud: "3-LabCloud"
            hostname: "lab-vm-01"
        instance:
          type: <instance-type-code>
          layout:
            id: <layout-id>
        plan:
          id: <plan-id>
        group:
          id: <group-id>
```

---

## Files

| File | Purpose |
|------|---------|
| `main.tf` | `split("-", var.cloud)[1]` + yamldecode |
| `variables.tf` | `cloud`, `hostname` |
| `terraform.tfvars` | ERB `customOptions` bindings |
| `LabCloud.yaml` | Cloud config when `cloud` ends with `-LabCloud` |
| (no provider) | Locals + outputs only — no Nutanix/Infoblox/null provider |

## Note on privcloud vs cloud

Salesforce case text references `var.privcloud`. The customer Git repo uses **`var.cloud`**. If your lab Morpheus inputs are named `privcloud`, either rename the TF variable to match or map the input to the `cloud` variable in tfvars:

```hcl
cloud = "<%=customOptions['privcloud']%>"
```

This repro uses `cloud` to match the published repo.

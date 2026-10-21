# Active Directory: Users, Groups, Memberships & Group Policy (Windows Server)

Hands-on lab where I installed and configured **Active Directory Domain Services (AD DS)** on a Windows Server VM, created a user and a group, managed group memberships, and created a **Group Policy Object (GPO)** to set a desktop wallpaper.

## Objectives

- Install and configure Active Directory with PowerShell scripts
- Create a user account and understand why it starts **disabled**
- Reset a password and force a change at next logon
- Create a security group and nest it inside another group
- Add and remove members from groups
- Create and link a GPO to an Organizational Unit (OU)

## Environment

| Item | Details |
|------|---------|
| OS | Windows Server (Qwiklabs VM, accessed over RDP) |
| Domain | `example.com` |
| Tools | PowerShell, Active Directory Administrative Center (ADAC), Group Policy Management |
| Lab platform | Google IT Support Certificate / Qwiklabs |

---

## Part 1: Install and configure Active Directory

Open **Windows PowerShell as Administrator** (Start menu → right-click Windows PowerShell → More → Run as administrator).

![Run PowerShell as administrator](screenshots/01-powershell-run-as-admin.png)

Run the installation script:

```powershell
C:\Qwiklabs\ADSetup\active_directory_install.ps1
```

The script prints some expected warnings, then the server restarts because AD DS was installed.

![AD DS install restart notice](screenshots/02-ad-install-restart-notice.png)

After the restart the RDP panel appears. I closed the tab and clicked **Open Windows VM** again to reconnect to the same VM (no need to re-run the install).

![RDP reconnect panel](screenshots/03-rdp-reconnect-panel.png)

Then I opened PowerShell as Administrator again and ran the configuration script:

```powershell
C:\Qwiklabs\ADSetup\configure_active_directory.ps1
```

---

## Part 2: Manage users and groups

### Open Active Directory Administrative Center

Search for **active** in the Start menu and open *Active Directory Administrative Center*.

![Search for Active Directory](screenshots/04-search-active-directory.png)

In ADAC I selected the `example (local)` domain and opened the **Users** container.

![Active Directory Administrative Center](screenshots/05-ad-administrative-center.png)

### Create the user Alex

Tasks pane → **Users → New → User**.

![New user menu](screenshots/06-new-user-menu.png)

Filled in the mandatory fields: full name `Alex` and logon name `alex`.

![Create User: Alex](screenshots/07-create-user-alex.png)

The new account shows as **Alex (Disabled)**. New accounts are created disabled until a valid password is set.

![Alex disabled, context menu](screenshots/08-alex-disabled-context-menu.png)

Trying to enable it without a password fails because it doesn't meet the domain's password requirements:

![Enable account error](screenshots/09-enable-account-password-error.png)

### Set a password and enable the account

Used **Reset password...** from the Tasks pane.

![Reset password task](screenshots/10-reset-password-task.png)

I left **User must change password at next log on** checked, so only the user knows their final password.

![Reset Password dialog](screenshots/11-reset-password-dialog.png)

After setting a compliant password, enabling the account worked.

### Create the group Python Developers

Tasks pane → **Users → New → Group**.

![New group menu](screenshots/12-new-group-menu.png)

Group name: `Python Developers` (Security group, Global scope).

![Create Group: Python Developers](screenshots/13-create-group-python-developers.png)

### Add Python Developers to the Developers group

Right-click the group → **Add to another group...**

![Add to another group](screenshots/14-add-to-another-group.png)

Entered `Developers` and confirmed.

![Select Groups: Developers](screenshots/15-select-group-developers.png)

### Add Alex to Python Developers

Double-clicked **Python Developers** to open its properties, then went to **Members**.

![Python Developers properties](screenshots/16-python-developers-properties.png)

Clicked **Add**, entered `Alex`, and saved.

![Add Alex as member](screenshots/17-add-alex-to-python-developers.png)

---

## Part 3: Edit memberships (Alosha moves from Java to Python)

Opened the properties of user **Alosha** → **Member Of**. Alosha belonged to *Domain Users* and *Java Developers*. I selected **Java Developers** and clicked **Remove**.

![Alosha Member Of](screenshots/18-alosha-member-of-java-developers.png)

Then clicked **Add**, entered `Python Developers`, and confirmed with OK.

![Add Alosha to Python Developers](screenshots/19-add-alosha-to-python-developers.png)

---

## Part 4: Group Policy (set a default wallpaper)

### Open Group Policy Management

Search for **group** in the Start menu and open *Group Policy Management*.

![Search for Group Policy Management](screenshots/20-search-group-policy-management.png)

### Create a GPO and link it to the Developers OU

Expanded `example.com`, right-clicked the **Developers** OU, and chose **Create a GPO in this domain, and Link it here...**

![Create a GPO and link it to Developers OU](screenshots/21-create-gpo-and-link-to-developers-ou.png)

Named the policy `New Wallpaper`.

![New GPO name](screenshots/22-new-gpo-name-new-wallpaper.png)

### Edit the policy

Right-clicked **New Wallpaper** → **Edit** (this opens the Group Policy Management Editor).

![Edit the GPO](screenshots/23-edit-gpo.png)

Navigated to:

`User Configuration > Policies > Administrative Templates > Desktop > Desktop`

and selected **Desktop Wallpaper**.

![Desktop Wallpaper policy](screenshots/24-desktop-wallpaper-policy-path.png)

Set it to **Enabled** and entered the wallpaper path:

```
C:\Qwiklabs\wallpaper.jpg
```

![Desktop Wallpaper enabled](screenshots/25-desktop-wallpaper-enabled.png)

### Verify the policy

Back in Group Policy Management, the **Settings** tab of `New Wallpaper` shows Desktop Wallpaper as the only configured setting, set to `C:\Qwiklabs\wallpaper.jpg`.

![GPO settings verification](screenshots/26-gpo-settings-verification.png)

---

## Key Takeaways

- Active Directory centralizes management of users, groups, computers and policies
- New accounts are disabled until a password that meets the domain policy is set
- "User must change password at next log on" keeps the admin from knowing the user's final password
- Groups can be nested (Python Developers inside Developers), and memberships can be edited from either the group or the user
- GPOs linked to an OU apply settings to everything in that OU
- Group membership changes (Java → Python) are a common real-world admin task when someone changes roles

## Skills Demonstrated

Active Directory administration · User and group management · Password policy · Group membership management · Group Policy (GPO) · Windows Server · PowerShell · Technical documentation

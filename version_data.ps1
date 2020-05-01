# Original bash format: {"version": VERSION,"repository": REPO,"branch": CURRENT,"is_dirty": T/F}

# Git commands
# Problem: Powershell has silently removed -NoNewline from Out-String, trim manually
[String]$mw_version = (git describe 2> $null) | Out-String
[String]$mw_repo = (git config --get remote.origin.url 2> $null) | Out-String
[String]$mw_branch = (git branch 2> $null) | Select-String -Pattern '[*]'
[String]$mw_current = $mw_branch.replace("* ","")
[String]$mw_changes = (git diff --quiet)

# Build the output string
[String]$v_string = '{"version": '
$v_string += if ($mw_version) { '"' + $mw_version.Trim() + '"' } else { 'None' }
$v_string += ',"repository": '
$v_string += if ($mw_repo) { '"' + $mw_repo.Trim() + '"' } else { 'None' }
$v_string += ',"branch": '
$v_string += if ($mw_current) { '"' + $mw_current.Trim() + '"' } else { 'None' }
$v_string += ',"is_dirty": '
$v_string += if ($mw_changes) { 'true' } else { 'false' }
$v_string += '}'

# Kill any new-lines that made it through
$v_out = $v_string.replace("`n","").replace("`r","")
$v_out| Out-File -Encoding ascii -FilePath version.txt
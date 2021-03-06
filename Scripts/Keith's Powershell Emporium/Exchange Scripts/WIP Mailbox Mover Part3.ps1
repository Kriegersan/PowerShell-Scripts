param( [string[]] $l, [string[]] $d)

if (($l.Count -gt 0) -AND ($d.Count -gt 0)) {

                Get-DistributionGroupMember -Identity $l[0]
                Get-DistributionGroupMember -Identity $l[0] | new-moverequest -targetDatabase $d[0] -BadItemLimit 120 -AcceptLargeDataLoss
}
else
{
   echo ""
   echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
   echo ""
   echo "Usage: MoveDL.ps1 -l <Universal DLName> -d <DB Name> "
   echo ""
   echo "Where -l equals the name of the universal DL whose members are to be moved."
   echo "and -d equals the target DB in 2010 that the users should be moved to."
   echo ""
   echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
   echo ""
}

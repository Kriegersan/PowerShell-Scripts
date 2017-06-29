Create W drive Powershell script Usage notes 

1. Needs to be run on a file server... such as Audrey <-- best server to run it from IPA, and others have worked. 

2. Use only for second Level DFS root such as W:\EMHS\IT Rules 
    it will NOT work for W:\Public\Projects\IT Rules 

3. It uses a CSV file! It can create more than one folder at a time!! 

4. It does DFS, AD groups, Folder creation. All thats left is to run the ABE Tool on DFS namespaces that need it. 


--Notes--

Any ideasto make this script complete? Let me know! 
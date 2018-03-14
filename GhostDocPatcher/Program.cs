using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Security.Principal;
using System.Windows.Forms;

namespace GhostDocPatcher
{
    internal static class Program
    {
        #region  Methods

        private static void Main()
        {
            try
            {
                Patch();

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }

            Console.ReadKey();
        }

        private static void Patch()
        {
            var patchStartTime = DateTime.Now;
            if (!new WindowsPrincipal(WindowsIdentity.GetCurrent()).IsInRole(WindowsBuiltInRole.Administrator))
            {
                MessageBox.Show("Patcher must be run as admin !", "Patcher for GhostDoc Enterprise/Pro",
                    MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                Application.Exit();
            }
            else
            {
                var processesByName = Process.GetProcessesByName("devenv");
                if (processesByName.Length != 1)//0
                {
                    MessageBox.Show("Please close Visual Studio !", "Patcher for GhostDoc Enterprise/Pro",
                        MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                    Application.Exit();
                }
                else
                {
                    var dllsFullPathList = new List<string>();
                    var ilByteArray = new byte[5][];
                    var newIlByteArray = new byte[5][];
                    var dictionary = new Dictionary<string, string>();
                    var pathchedDllCount = 0;
                    var lastMessage = "";

                    if (Directory.Exists(Environment.CurrentDirectory))
                    {
                        foreach (var item in Directory.GetFiles(Environment.CurrentDirectory,
                            "SubMain.GhostDoc.Services*.dll",
                            SearchOption.AllDirectories)) dllsFullPathList.Add(item);

                        foreach (var item2 in Directory.GetFiles(Environment.CurrentDirectory,
                            "SubMain.GhostDoc.Package*.dll",
                            SearchOption.AllDirectories)) dllsFullPathList.Add(item2);
                    }

                    if (dllsFullPathList.Count == 0)
                    {
                        MessageBox.Show("No DLLs found !", "Patcher for GhostDoc Enterprise/Pro", MessageBoxButtons.OK,
                            MessageBoxIcon.Asterisk);
                        Application.Exit();
                    }
                    else
                    {
                        foreach (var dllFullPath in dllsFullPathList)
                        {
                            var sameDllFindCount = 0;
                            var servicesDllCount = 2;
                            byte[] thisDllAllBytes;
                            try
                            {
                                thisDllAllBytes = File.ReadAllBytes(dllFullPath);
                                ilByteArray[0] = new byte[] { 85, 139, 236, byte.MaxValue, 53, 0 };
                                newIlByteArray[0] = new byte[] { 184, byte.MaxValue, byte.MaxValue, byte.MaxValue, 0, 195 };
                                ilByteArray[1] = new byte[] { 85, 139, 236, 106, byte.MaxValue, 104, 144, 84 };
                                newIlByteArray[1] = new byte[] { 184, byte.MaxValue, byte.MaxValue, byte.MaxValue, 0, 195 };
                                ilByteArray[2] = new byte[]
                                {
                                    60, 97, 32, 104, 114, 101, 102, 61, 34, 104, 116, 116, 112, 58, 47, 47, 115, 117,
                                    98, 109, 97, 105,110, 46, 99, 111, 109, 47, 102, 119, 108, 105, 110, 107, 47, 103, 100, 45, 104, 101,
                                    108, 112, 47, 103,101, 110, 101, 114, 97, 116, 101, 100, 47, 34, 62, 67, 114, 101, 97, 116,
                                    101, 100, 32, 119, 105, 116, 104, 32, 101, 118, 97, 108, 117, 97, 116, 105, 111,
                                    110, 32,99, 111, 112, 121, 32, 111, 102, 32, 123, 48, 125, 46, 32, 67, 108, 105, 99,
                                    107, 32, 104, 101, 114, 101, 32, 116, 111, 32, 112, 117, 114, 99, 104, 97, 115,
                                    101, 32, 97, 110, 100, 32, 114, 101, 109, 111, 118, 101, 32, 116, 104, 105, 115,
                                    32, 108, 105, 110, 107, 46, 60, 47, 97, 62
                                };
                                newIlByteArray[2] = new byte[]
                                {
                                    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,
                                    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,
                                    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,
                                    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,
                                    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,
                                    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,
                                    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
                                };
                                if (dllFullPath.IndexOf("SubMain.GhostDoc.Package", StringComparison.Ordinal) != -1)
                                {
                                    var assembly = Assembly.Load(thisDllAllBytes);
                                    //var assemblyVersionNums = assembly.FullName.Split(',')[1].Replace("Version=", "").Split('.');
                                    //if (Convert.ToInt32(assemblyVersionNums[0]) * 10 + Convert.ToInt32(assemblyVersionNums[1]) >= 53)
                                    //{//检测版本号>53
                                    Type[] thisDllTypesArr;
                                    try
                                    {
                                        thisDllTypesArr = assembly.GetTypes();
                                    }
                                    catch (ReflectionTypeLoadException ex)
                                    {
                                        thisDllTypesArr = ex.Types;
                                    }

                                    foreach (var type in thisDllTypesArr)
                                    {
                                        if (type != null)
                                        {
                                            foreach (var methodInfo in type.GetMethods(BindingFlags.Static | BindingFlags.NonPublic))
                                            {
                                                try
                                                {
                                                    var method = methodInfo.ToString();
                                                    if (method.IndexOf("(System.String, Byte[])", StringComparison.Ordinal) > 0 &&
                                                        methodInfo.ReturnType.ToString() == "System.Boolean")
                                                    {
                                                        servicesDllCount++;
                                                        ilByteArray[servicesDllCount] = methodInfo.GetMethodBody().GetILAsByteArray();
                                                        newIlByteArray[servicesDllCount] = new byte[ilByteArray[servicesDllCount].Length];
                                                        newIlByteArray[servicesDllCount][0] = 23;
                                                        newIlByteArray[servicesDllCount][ilByteArray[servicesDllCount].Length - 1] = 42;
                                                    }
                                                }
                                                catch (Exception ex)
                                                {
                                                    Console.WriteLine(ex);
                                                }
                                            }
                                        }
                                    }
                                    //}
                                }
                            }
                            catch
                            {
                                continue;
                            }

                            for (var i = 0; i <= servicesDllCount; i++)
                                for (var j = 0; j < thisDllAllBytes.Length - ilByteArray[i].Length; j++)
                                {
                                    for (var k = 0; k < ilByteArray[i].Length; k++)
                                        if (thisDllAllBytes[j + k] != ilByteArray[i][k])
                                        {
                                            break;
                                        }


                                    using (var fileStream = new FileStream(dllFullPath, FileMode.Open, FileAccess.Write))
                                    {
                                        fileStream.Seek(j, SeekOrigin.Begin);
                                        fileStream.Write(newIlByteArray[i], 0, newIlByteArray[i].Length);
                                    }

                                    sameDllFindCount++;
                                    if (!dictionary.ContainsKey(dllFullPath))
                                    {
                                        pathchedDllCount++;
                                        dictionary.Add(dllFullPath, "OK");
                                        lastMessage = string.Concat(lastMessage, pathchedDllCount, ": ", dllFullPath, "\r\n");
                                    }

                                    break;
                                }

                            lastMessage = string.Concat(lastMessage, "(", sameDllFindCount, sameDllFindCount > 1 ? " locations)" : " location)", "\r\n\r\n");
                        }

                        var patchEndTime = DateTime.Now;

                        MessageBox.Show(pathchedDllCount > 0
                                ?
$@"Patching finished ! 

The following {pathchedDllCount} assemblie(s) were patched in {(int)(patchEndTime - patchStartTime).TotalMilliseconds} milliseconds: 

{lastMessage}" : "No assembly was patched !", "Patcher for GhostDoc Enterprise/Pro", MessageBoxButtons.OK,
                            MessageBoxIcon.Asterisk);
                        Application.Exit();
                    }
                }
            }
        }

        #endregion
    }
}
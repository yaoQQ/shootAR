
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class ResourceManager : Singleton<ResourceManager>
{
    private Dictionary<string, GameObject> PrefabDic=new Dictionary<string, GameObject>();//特效对象池
   


    public void clear()
    {

        PrefabDic.Clear();

    }
    public GameObject getPrefabByPath(string path)
    {
        GameObject obj = null;
        if (PrefabDic.ContainsKey(path))
        {
            obj = PrefabDic[path];
        }
        else
        {
            obj = Resources.Load(path) as GameObject;

            PrefabDic.Add(path, obj);
        }
        return obj;
    }

   
}


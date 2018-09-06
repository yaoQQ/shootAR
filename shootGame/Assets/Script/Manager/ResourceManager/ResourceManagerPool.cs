using System.Collections.Generic;
using UnityEngine;

public class ResourceManagerPool:Singleton<ResourceManagerPool>
{
    private Dictionary<string, ResourcePoolItem> _poolItemCache = new Dictionary<string, ResourcePoolItem>();
    private static GameObject _poolManagerContent = null;



    public GameObject GetGameObject(string name, ResourceType type)
    {
		GameObject resultObj = null;
        string fullPath = GetPrefabFullPath(name, type);

        if (_poolItemCache.ContainsKey(fullPath) == true)
			resultObj = _poolItemCache[fullPath].GetInstantiate();
        else
        {
            Object prefab = GetPrefab(fullPath);
			resultObj = Object.Instantiate(prefab) as GameObject;
        }

		SetGameObjectName (resultObj, name, type);
		return resultObj;
    }

    //attachPrefab 是否已预制件设置初始化
    public GameObject GetPoolObject(string name, ResourceType type, bool attachPrefab=false)
    {
        string fullPath = GetPrefabFullPath(name, type);

        ResourcePoolItem poolItem = null;
        if (_poolItemCache.ContainsKey(fullPath) == true)
            poolItem = _poolItemCache[fullPath];
        else
        {
            poolItem = new ResourcePoolItem(fullPath);
            _poolItemCache[fullPath] = poolItem;
        }

		GameObject resultObj = poolItem.GetFromPool(attachPrefab);
        if (resultObj == null) return null;
		SetGameObjectName (resultObj, name, type);

        ResourcePoolEnable poolEnable = resultObj.GetComponent<ResourcePoolEnable>();
        if (poolEnable != null)
        {
            poolEnable.prefabName = name;
            poolEnable.Active();
        }
 
        return resultObj;
    }

    private void SetGameObjectName(GameObject obj, string name, ResourceType type)
	{
		obj.name = type.ToString() + "_" + name;
	}

    public void ReturnPoolObject(string name, ResourceType type, GameObject obj)
    {
        if (_poolManagerContent == null)
        {
            _poolManagerContent = new GameObject("_poolManagerContent");
        }
        string fullPath = GetPrefabFullPath(name, type);
        if (_poolItemCache.ContainsKey(fullPath) == false)
            return;

		obj.transform.parent = _poolManagerContent.transform;
        _poolItemCache[fullPath].AddToPool(obj);
    }

    public static Object GetPrefab(string prefabFulPath)
    {
		Object loadObject =  Resources.Load(prefabFulPath, typeof(Object));
        return loadObject;
    }

    public static string GetPrefabFullPath(string prefabName, ResourceType type)
    {
        string path = "";
		if (type == ResourceType.bullet) {
         
            path = "Prefabs/Shoot/Bullet/";
		} else if (type == ResourceType.effect) {
			path = "Prefabs/Shoot/Effects/";
		}
        else if (type == ResourceType.gun)
        {
            path = "Prefabs/Shoot/Gun/";
        }
        else if (type == ResourceType.ship) {
			path = "Prefabs/Shoot/Model/Ships/";
        }
        else if (type == ResourceType.UI)
        {
            path = "Prefabs/Shoot/UI/";
        }
        else if (type == ResourceType.scene) {
			path = "Prefabs/Scenes/";
		}
		string fullPath = path + prefabName;
        return fullPath;
    }

 
}

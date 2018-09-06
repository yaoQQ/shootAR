using System.Collections.Generic;
using UnityEngine;

public class ResourcePoolItem
{
    private const int POOL_MAX = 12;

    private GameObject _resPrefab = null;
    private List<GameObject> _objList = null;

    public ResourcePoolItem(string prefabFullPath)
    {
		_resPrefab = ResourceManager.Instance.getPrefabByPath(prefabFullPath);
        _objList = new List<GameObject>();
    }

    public void AddToPool(GameObject obj)
    {
		if (_objList.Count >= POOL_MAX) 
		{
			GameObject.Destroy (obj);
			return;
		}
            

        if (_objList.Contains(obj) == true)
            return;

        obj.SetActive(false);
        _objList.Add(obj);
    }

    public GameObject GetFromPool(bool attachPrefab)
    {
      //  Debug.Log(_resPrefab.name+" totalPool,count="+ _objList.Count);
        GameObject getObj = null;
        if (_objList.Count > 0)
        {
            getObj = _objList[_objList.Count - 1];
            _objList.RemoveAt(_objList.Count - 1);
        }
        else
        {
            getObj = GetInstantiate();
            if (attachPrefab)
            {
                getObj.transform.localPosition = _resPrefab.transform.position;
                getObj.transform.localEulerAngles = _resPrefab.transform.eulerAngles;
                getObj.transform.localScale = _resPrefab.transform.localScale;
            }
        }
        if(getObj!=null)
        getObj.SetActive(true);

       // Debug.Log(_resPrefab.name + "_objList.count=" + _objList.Count);
        
        return getObj;
    }
    public GameObject GetFromPool()
    {
        //  Debug.Log(_resPrefab.name+" totalPool,count="+ _objList.Count);
        GameObject getObj = null;
        if (_objList.Count > 0)
        {
            getObj = _objList[_objList.Count - 1];
            _objList.RemoveAt(_objList.Count - 1);
        }
        else
            getObj = GetInstantiate();

        getObj.SetActive(true);

        Debug.Log(_resPrefab.name + "_objList.count=" + _objList.Count);

        return getObj;
    }

    public GameObject GetInstantiate()
    {
        return Object.Instantiate(_resPrefab) as GameObject;
    }


    
}
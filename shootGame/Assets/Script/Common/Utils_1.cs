using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class Utils_1
{

    private static string prefabPath = "Prefabs/";
    public static float modelScale = 0.01f;
    public static GameObject LoadPrefab(string path)
    {
        GameObject obj = ResourceManager.Instance.getPrefabByPath(path) as GameObject;
        //GameObject prefabClone = GameObject.Instantiate(obj) as GameObject;
        //prefabClone.transform.localPosition = Vector3.zero;
        //prefabClone.transform.localScale = Vector3.one;
        return obj;
    }
    public static GameObject LoadUIPrefab(string path)
    {
        string UIPath = "Prefabs/Shoot/UI/";
        GameObject obj = LoadPrefab(UIPath + path) as GameObject;
        GameObject prefabClone = GameObject.Instantiate(obj) as GameObject;

        prefabClone.transform.localPosition = Vector3.zero;
        prefabClone.transform.localScale = Vector3.one;
        return prefabClone;
    }
    public static GameObject LoadModelPrefab(string path)
    {
        string modelPath = "Prefabs/Shoot/Model/";
        GameObject obj = LoadPrefab(modelPath + path) as GameObject;
        GameObject prefabClone = GameObject.Instantiate(obj) as GameObject;
     
        prefabClone.transform.localPosition = Vector3.zero;
        prefabClone.transform.localScale = Vector3.one* modelScale;
        return prefabClone;
    }
    public static GameObject LoadEffectPrefab(string path, GameObject parent = null)
    {
        string effectPath = "Prefabs/Shoot/Effects/";
        GameObject obj = LoadPrefab(effectPath + path) as GameObject;
        GameObject prefabClone = GameObject.Instantiate(obj) as GameObject;
        if (parent != null)
        {
            prefabClone.transform.parent = parent.transform;
        }
        prefabClone.transform.localPosition = Vector3.zero;
        prefabClone.transform.localScale = Vector3.one;
        return prefabClone;
    }
    public static GameObject LoadBulletPrefab(string bulletName)
    {

        string bulletPath = "Prefabs/Shoot/Bullet/";
        GameObject obj = LoadPrefab(bulletPath + bulletName);
        GameObject gunBullet = GameObject.Instantiate(obj) as GameObject;

        gunBullet.transform.localPosition = Vector3.zero;
        gunBullet.transform.localScale = Vector3.one;
        return gunBullet;
    }
    public static GameObject getAttackPrefab(string path)
    {
        GameObject gunBullet = null;
        string effectPath = "Prefabs/AttackFX/";
        if (!string.IsNullOrEmpty(path))
        {
            UnityEngine.Object obj = Resources.Load(effectPath + path);
            gunBullet = obj as GameObject;
        }
        return gunBullet;
    }

    public static GameObject Instantiate(GameObject cloneTarget)
    {
        if (cloneTarget == null)
            return null;
        GameObject prefabClone = GameObject.Instantiate(cloneTarget) as GameObject;
        if (cloneTarget.transform.parent != null)
            prefabClone.transform.parent = cloneTarget.transform.parent;
        prefabClone.transform.localPosition = Vector3.zero;
        prefabClone.transform.localScale = Vector3.one;
        return prefabClone;
    }
    public static GameObject Instantiate(GameObject cloneTarget, GameObject parent)
    {
        if (cloneTarget == null)
            return null;
        GameObject prefabClone = GameObject.Instantiate(cloneTarget) as GameObject;
        prefabClone.transform.localPosition = cloneTarget.transform.position;
        prefabClone.transform.localScale = cloneTarget.transform.localScale;
        prefabClone.transform.localRotation = cloneTarget.transform.localRotation;
        prefabClone.transform.parent = parent.transform;
        return prefabClone;
    }



    public static GameObject[] CalculateEnemiesByDistance(GameObject[] enemies, float distance, Transform player)
    {
        if (enemies == null)
        {
            return null;
        }
        List<GameObject> enemyList = new List<GameObject>();
        int size = enemies.Length;
        for (int cnt = 0; cnt < size; cnt++)
        {
            float temp = Vector3.Distance(enemies[cnt].transform.position, player.position);
            if (temp <= distance)
            {
                enemyList.Add(enemies[cnt]);
            }
        }
        return enemyList.ToArray();
    }
    public static GameObject[] CalculateEnemiesByAngle(GameObject[] enemies, float angle, Transform player)
    {
        if (enemies == null)
        {
            return null;
        }
        List<GameObject> enemyList = new List<GameObject>();
        int size = enemies.Length;
        for (int cnt = 0; cnt < size; cnt++)
        {
            GameObject enemy;
            if ((enemy = CalculateEnemyByAngle(enemies[cnt], angle, player)) != null)
            {
                enemyList.Add(enemy);
            }
        }
        return enemyList.ToArray();
    }
    private static GameObject CalculateEnemyByAngle(GameObject enemy, float angle, Transform player)
    {
        Vector3 playerForward = player.transform.forward.normalized;
        Vector3 enemyDir = (enemy.transform.position - player.transform.position).normalized;
        float dotAngle = Vector3.Dot(playerForward, enemyDir);  // [-1, 1]
        float targetDotAngle = Mathf.Cos(Mathf.Deg2Rad * angle);
        if (angle < 90)
        {
            if (dotAngle >= targetDotAngle)
            {
                return enemy;
            }
            else
            {
                return null;
            }
        }
        else if (angle == 90)
        {
            if (dotAngle >= 0)
            {
                return enemy;
            }
            else
            {
                return null;
            }
        }
        else if (angle > 90)
        {
            if (dotAngle >= 0)
            {
                return enemy;
            }
            else if (dotAngle >= targetDotAngle)
            {
                return enemy;
            }
            else
            {
                return null;
            }
        }
        else
        {
            return null;
        }
    }




}


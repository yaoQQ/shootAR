using UnityEngine;
using System.Collections;

/// <summary>
/// 定义单例模板基类。
/// 优点：不需要手动绑定单例到游戏对象就可以使用。
/// 缺点：这些都是游戏对象，在unity3d中只能在主线程中进行调用。所以网络多线程方面会产生单例的不唯一性，在这里就可以忽略了。
/// </summary>
/// <typeparam name="T"></typeparam>
public class SingletonMomo<T> : MonoBehaviour where T : MonoBehaviour {

    private static T instance;

    public static T Instance {
        get {
            if (!instance) {
                GameObject singleton = new GameObject();
                singleton.name = "Singleton-" + typeof(T).Name;
                instance = singleton.AddComponent<T>();
            }
            return instance;
        }
    }

    protected virtual void OnApplicationQuit() {
        instance = null;
    }

}

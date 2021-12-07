using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Playables;

public class DeleteUnused : EditorWindow
{
    [MenuItem("GameObject/Tools/Timeline/Unusedを消去",false,1)]
    static void Delete()
    {
        List<GameObject> objects = new List<GameObject>();
        var pd =  Selection.activeGameObject.GetComponent<PlayableDirector>();
        var asset = pd.playableAsset;
        var path = AssetDatabase.GetAssetPath(asset);
        // シリアライズ化
        var so = new SerializedObject(pd);
        so.Update();

        // m_SceneBindingsの変数を取得
        var prop = so.FindProperty("m_SceneBindings");
        
        for (int i = 0; i < prop.arraySize; i++)
        {
            // m_SceneBindingsの配列のi番目のkeyのプロパティを取得
            var key = prop.GetArrayElementAtIndex(i).FindPropertyRelative("key");
            // keyの参照しているオブジェクトのインスタンスIDを取得
            var tmp = key.objectReferenceInstanceIDValue;
            // インスタンスIDを元にアセットのパスを取得する
            var propPath = AssetDatabase.GetAssetPath(tmp);
            Debug.Log(propPath);
            
            if (path != propPath)
            {
                prop.DeleteArrayElementAtIndex(i);
                i--;
            }
        }
        so.ApplyModifiedProperties();
        Debug.Log("完了");
    }
}
